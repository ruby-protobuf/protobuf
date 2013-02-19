module Protobuf
  module Rpc
    module Zmq

      WORKER_READY_MESSAGE = "WORKER_READY"

      module Util
        include ::Protobuf::Logger::LogMethods
        def self.included(base)
          base.extend(::Protobuf::Rpc::Zmq::Util)
        end

        def zmq_error_check(return_code, source)
          unless ::ZMQ::Util.resultcode_ok?(return_code)
            raise <<-ERROR
            Last ZMQ API call to #{source} failed with "#{::ZMQ::Util.error_string}".

            #{caller(1).join($/)}
            ERROR
          end
        end

        def log_signature
          @_log_signature ||= "server-#{self.class}-#{object_id}"
        end

        def resolve_ip(hostname)
          ::Resolv.getaddress(hostname)
        end

      end

    end
  end
end
