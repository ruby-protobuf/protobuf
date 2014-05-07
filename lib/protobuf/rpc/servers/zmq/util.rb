require 'resolv'

module Protobuf
  module Rpc
    module Zmq

      ADDRESS_MATCH = /\A\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\z/.freeze
      WORKER_READY_MESSAGE = "\1"
      CHECK_AVAILABLE_MESSAGE = "\3"
      NO_WORKERS_AVAILABLE = "\4"
      WORKERS_AVAILABLE = "\5"

      module Util
        include ::Protobuf::Logging

        def self.included(base)
          base.extend(::Protobuf::Rpc::Zmq::Util)
        end

        def zmq_error_check(return_code, source = nil)
          unless ::ZMQ::Util.resultcode_ok?(return_code)
            raise <<-ERROR
            Last ZMQ API call #{source ? "to #{source}" : ""} failed with "#{::ZMQ::Util.error_string}".

            #{caller(1).join($/)}
            ERROR
          end
        end

        def resolve_ip(hostname)
          ::Resolv.getaddresses(hostname).detect do |address|
            address =~ ADDRESS_MATCH
          end
        end
      end
    end
  end
end
