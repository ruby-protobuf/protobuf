require 'protobuf/rpc/connectors/base'
require 'protobuf/rpc/service_directory'

module Protobuf
  module Rpc
    module Connectors
      class Zmq < Base

        RequestTimeout = Class.new(RuntimeError)

        ##
        # Included Modules
        #

        include Protobuf::Rpc::Connectors::Common
        include Protobuf::Logger::LogMethods

        ##
        # Class Constants
        #

        CLIENT_RETRIES = (ENV['PB_CLIENT_RETRIES'] || 3)

        ##
        # Class Methods
        #
        def self.zmq_context
          @zmq_contexts ||= Hash.new { |hash, key|
            hash[key] = ZMQ::Context.new
          }

          @zmq_contexts[Process.pid]
        end

        ##
        # Instance methods
        #

        # Start the request/response cycle. We implement the Lazy Pirate
        # req/reply reliability pattern as laid out in the ZMQ Guide, Chapter 4.
        #
        # @see http://zguide.zeromq.org/php:chapter4#Client-side-Reliability-Lazy-Pirate-Pattern
        #
        def send_request
          setup_connection
          send_request_with_lazy_pirate unless error?
        end

        def log_signature
          @_log_signature ||= "[client-#{self.class}]"
        end

        private

        ##
        # Private Instance methods
        #

        def close_connection
          # The socket is automatically closed after every request.
        end

        # Create a socket connected to a server that can handle the current
        # service. The LINGER is set to 0 so we can close immediately in
        # the event of a timeout
        def create_socket
          server_uri = lookup_server_uri

          socket = zmq_context.socket(::ZMQ::REQ)
          socket.setsockopt(::ZMQ::LINGER, 0)

          log_debug { sign_message("Establishing connection: #{server_uri}") }
          zmq_error_check(socket.connect(server_uri), :socket_connect)
          log_debug { sign_message("Connection established to #{server_uri}") }

          socket
        end

        # Method to determine error state, must be used with Connector API.
        #
        def error?
          !! @error
        end

        # Lookup a server uri for the requested service in the service
        # directory. If the service directory is not running, default
        # to the host and port in the options
        #
        def lookup_server_uri
          begin
            listing = service_directory.lookup(service)

            host = listing.try(:address) || options[:host]
            port = listing.try(:port) || options[:port]
          end until host_alive?( host )

          "tcp://#{host}:#{port}"
        end

        def host_alive?(host)
          return true unless ping_port_enabled?

          socket = TCPSocket.new(host, ping_port.to_i)

          true
        rescue
          false
        ensure
          socket.close rescue nil
        end

        # Trying a number of times, attempt to get a response from the server.
        # If we haven't received a legitimate response in the CLIENT_RETRIES number
        # of retries, fail the request.
        #
        def send_request_with_lazy_pirate
          attempt = 0
          timeout = options[:timeout].to_f

          begin
            attempt += 1
            send_request_with_timeout(timeout, attempt)
            parse_response
          rescue RequestTimeout
            retry if attempt < CLIENT_RETRIES
            fail(:RPC_FAILED, "The server repeatedly failed to respond within #{timeout} seconds")
          end
        end

        def send_request_with_timeout(timeout, attempt = 0)
          socket = create_socket

          poller = ::ZMQ::Poller.new
          poller.register_readable(socket)

          log_debug { sign_message("Sending Request (attempt #{attempt}, #{socket})") }
          zmq_error_check(socket.send_string(@request_data), :socket_send_string)
          log_debug { sign_message("Waiting #{timeout} seconds for response (attempt #{attempt}, #{socket})") }

          if poller.poll(timeout * 1000) == 1
            zmq_error_check(socket.recv_string(@response_data = ""), :socket_recv_string)
            log_debug { sign_message("Response received (attempt #{attempt}, #{socket})") }
          else
            log_debug { sign_message("Timed out waiting for response (attempt #{attempt}, #{socket})") }
            raise RequestTimeout
          end
        ensure
          unless socket.nil?
            log_debug { sign_message("Closing Socket")  }
            zmq_error_check(socket.close, :socket_close)
            log_debug { sign_message("Socket closed")  }
          end
        end

        # The service we're attempting to connect to
        #
        def service
          options[:service]
        end

        # Alias for ::Protobuf::Rpc::ServiceDirectory.instance
        def service_directory
          ::Protobuf::Rpc::ServiceDirectory.instance
        end

        # Return the ZMQ Context to use for this process.
        # If the context does not exist, create it, then register
        # an exit block to ensure the context is terminated correctly.
        #
        def zmq_context
          self.class.zmq_context
        end

        def zmq_error_check(return_code, source)
          unless ::ZMQ::Util.resultcode_ok?(return_code || -1)
            raise <<-ERROR
            Last ZMQ API call to #{source} failed with "#{::ZMQ::Util.error_string}".

            #{caller(1).join($/)}
            ERROR
          end
        end
      end
    end
  end
end
