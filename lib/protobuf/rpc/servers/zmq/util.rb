module Protobuf
  module Rpc
    module Zmq

      module Util
        include ::Protobuf::Logger::LogMethods
        def self.included(base)
          base.extend(::Protobuf::Rpc::Zmq::Util)
        end

        def zmq_error_check(return_code)
          raise "Last API call failed with \"#{::ZMQ::Util.error_string}\"#{$/}#{$/}#{caller(1)}" unless return_code >= 0
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
