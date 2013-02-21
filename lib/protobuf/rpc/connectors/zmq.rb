require 'protobuf/rpc/connectors/base'

module Protobuf
  module Rpc
    module Connectors
      class Zmq < Base

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
        # Instance methods
        #

        # Start the request/response cycle. We implement the Lazy Pirate
        # req/reply reliability pattern as laid out in the ZMQ Guide, Chapter 4.
        #
        # @see http://zguide.zeromq.org/php:chapter4#Client-side-Reliability-Lazy-Pirate-Pattern
        #
        def send_request
          setup_connection
          poll_send_data
        ensure
          close_connection
        end

        def log_signature
          @_log_signature ||= "[client-#{self.class}]"
        end

        private

        ##
        # Private Instance methods
        #

        def close_connection
          socket_close
          zmq_context_terminate
        end

        # Establish a request socket connection to the remote rpc_server.
        # Set the socket option LINGER to 0 so that we don't wait
        # for queued messages to be accepted when the socket/context are
        # asked to close/terminate.
        #
        def connect_to_rpc_server
          return if error?

          location = "#{options[:host]}:#{options[:port]}"
          log_debug { sign_message("Establishing connection: #{location}") }
          socket.setsockopt(::ZMQ::LINGER, 0)
          zmq_error_check(socket.connect("tcp://#{location}"), :socket_connect)
          zmq_error_check(poller.register_readable(socket), :poller_register_readable)
          log_debug { sign_message("Connection established to #{location}") }
        end

        # Method to determine error state, must be used with Connector API.
        #
        def error?
          !! @error
        end

        # Trying a number of times, attempt to get a response from the server.
        # If we haven't received a legitimate response in the CLIENT_RETRIES number
        # of retries, fail the request.
        #
        def poll_send_data
          return if error?

          poll_timeout = (options[:timeout].to_f / CLIENT_RETRIES.to_f) * 1000

          CLIENT_RETRIES.times do |n|
            connect_to_rpc_server
            log_debug { sign_message("Sending Request (attempt #{n + 1}, #{socket})") }
            send_data
            log_debug { sign_message("Request sending complete (attempt #{n + 1}, #{socket})") }

            if poller.poll(poll_timeout) == 1
              read_response
              return
            else
              socket_close
            end
          end

          fail(:RPC_FAILED, "The server took longer than #{options[:timeout]} seconds to respond")
        end

        def poller
          @poller ||= ::ZMQ::Poller.new
        end

        # Read the string response from the available readable. This will be
        # the current @socket. Calls `parse_response` to invoke the success or
        # failed callbacks, depending on the state of the communication
        # and response data.
        #
        def read_response
          return if error?

          poller.readables.each do |readable|
            @response_data = ''
            zmq_error_check(readable.recv_string(@response_data), :socket_recv_string)
          end

          parse_response
        end

        # Send the request data to the remote rpc_server.
        #
        def send_data
          return if error?

          @stats.request_size = @request_data.size
          zmq_error_check(socket.send_string(@request_data), :socket_send_string)
        end

        # Setup a ZMQ request socket in the current zmq context.
        #
        def socket
          @socket ||= zmq_context.socket(::ZMQ::REQ)
        end

        def socket_close
          if socket
            log_debug { sign_message("Closing Socket")  }
            zmq_error_check(socket.close, :socket_close)
            log_debug { sign_message("Socket closed")  }
            @socket = nil
          end
        end

        # Return the ZMQ Context to use for this process.
        # If the context does not exist, create it, then register
        # an exit block to ensure the context is terminated correctly.
        #
        def zmq_context
          @zmq_context ||= ::ZMQ::Context.new
        end

        # Terminate the zmq_context (if any).
        #
        def zmq_context_terminate
          log_debug { sign_message("Terminating ZMQ Context")  }
          @zmq_context.try(:terminate)
          @zmq_context = nil
          log_debug { sign_message("ZMQ Context terminated")  }
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
