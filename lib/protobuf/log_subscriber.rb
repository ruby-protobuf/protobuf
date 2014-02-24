require 'active_support/log_subscriber'

class ::Protobuf::LogSubscriber < ::ActiveSupport::LogSubscriber
  class << self
    def logger
      @logger ||= ::Protobuf::Logger.instance
    end
  end

  def handle_request(event)
    return unless logger.info?

    payload       = event.payload
    response      = payload[:response]
    status        = 'OK'
    request_size  = "#{payload[:encoded_request].size}B"
    response_size = "#{payload[:encoded_response].size}B"
    service_name  = payload[:service_name]
    method_name   = payload[:method_name]
    client        = payload[:client_host]

    if response.is_a?(::Protobuf::Rpc::PbError)
      status = "FAILED (#{response.message})"
    end

    if service_name && method_name
      rpc = "rpc=#{service_name}##{:method_name}"
    else
      rpc = nil
    end

    bytes = "i/o=#{request_size}/#{response_size}"

    info([status, "client=#{client}", rpc, bytes].compact.join(' '))
  end

  protected

  def logger
    self.class.logger
  end
end

::Protobuf::LogSubscriber.attach_to :protobuf
