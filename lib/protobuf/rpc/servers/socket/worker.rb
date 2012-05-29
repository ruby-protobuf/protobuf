module Protobuf
  module Rpc
    module Socket

      class Worker
        include ::Protobuf::Rpc::Server
        include ::Protobuf::Logger::LogMethods

        def initialize(sock, &complete_cb)
          @did_response = false
          @socket = sock
          @request = Protobuf::Socketrpc::Request.new
          @response = Protobuf::Socketrpc::Response.new
          request_buffer = Protobuf::Rpc::Buffer.new(:read)
          @stats = Protobuf::Rpc::Stat.new(:SERVER, true)
          @complete_cb = complete_cb
          log_debug { "[#{log_signature}] Post init, new read buffer created" }

          @stats.client = ::Socket.unpack_sockaddr_in(@socket.getpeername)
          log_debug { "stats are #{@stats.to_s}" }
          request_buffer << read_data
          @request_data = request_buffer.data

          @stats.request_size = request_buffer.size

          log_debug { "[#{log_signature}] handling request" }
          handle_client if request_buffer.flushed?
        end

        def log_signature
          @log_signature ||= "server-#{self.class}-#{object_id}"
        end

        def read_data
          size_io = StringIO.new

          while((size_reader = @socket.getc) != "-")
            size_io << size_reader
          end
          str_size_io = size_io.string

          "#{str_size_io}-#{@socket.read(str_size_io.to_i)}"
        end

        def send_data
          response_buffer = Protobuf::Rpc::Buffer.new(:write)
          response_buffer.set_data(@response)
          @stats.response_size = response_buffer.size
          log_debug { "[#{log_signature}] sending data : %s" % response_buffer.write }
          @socket.write(response_buffer.write)
          @socket.flush
          @complete_cb.call(@socket)
        end
      end

    end
  end
end
