require 'protobuf/rpc/server'
require 'protobuf/logger'

module Protobuf
  module Rpc
    module Socket

      class Worker
        include ::Protobuf::Rpc::Server
        include ::Protobuf::Logger::LogMethods

        def initialize(sock, &complete_cb)
          @socket = sock
          initialize_request!

          request_buffer = Protobuf::Rpc::Buffer.new(:read)
          @complete_cb = complete_cb

          log_debug { sign_message("stats are #{@stats.to_s}") }
          request_buffer << read_data
          @request_data = request_buffer.data

          @stats.request_size = request_buffer.size

          log_debug { sign_message("handling request") }
          handle_client if request_buffer.flushed?
        end

        def read_data
          size_io = StringIO.new

          until (size_reader = @socket.getc) == "-"
            size_io << size_reader
          end
          str_size_io = size_io.string

          "#{str_size_io}-#{@socket.read(str_size_io.to_i)}"
        end

        def send_data
          raise 'Socket closed unexpectedly' unless socket_writable?
          response_buffer = Protobuf::Rpc::Buffer.new(:write)
          response_buffer.set_data(@response)
          @stats.response_size = response_buffer.size
          log_debug { sign_message("sending data : #{response_buffer.data}") }
          @socket.write(response_buffer.write)
          @socket.flush
          @complete_cb.call(@socket)
        end

        def log_signature
          @_log_signature ||= "server-#{self.class}-#{object_id}"
        end

        def set_peer
          @stats.client = ::Socket.unpack_sockaddr_in(@socket.getpeername)
        end

        def socket_writable?
          ! @socket.nil? && ! @socket.closed?
        end
      end

    end
  end
end
