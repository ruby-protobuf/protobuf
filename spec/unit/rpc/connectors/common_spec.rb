require 'spec_helper'
require 'protobuf/rpc/service'

describe Protobuf::Rpc::Connectors::Common do
  let(:common_class) do 
    Class.new(Protobuf::Rpc::Connectors::Base) do
      include Protobuf::Rpc::Connectors::Common 
      attr_accessor :options
    end
  end

  subject{ common_class.new({}) }

  # Check our definition of the "API"
  specify{ subject.respond_to?(:any_callbacks?).should be_true }
  specify{ subject.respond_to?(:data_callback).should be_true }
  specify{ subject.respond_to?(:error).should be_true }
  specify{ subject.respond_to?(:fail).should be_true }
  specify{ subject.respond_to?(:complete).should be_true }
  specify{ subject.respond_to?(:parse_response).should be_true }
  specify{ subject.respond_to?(:_send_request).should be_true }
  specify{ subject.respond_to?(:verify_options).should be_true }
  specify{ subject.respond_to?(:verify_callbacks).should be_true }

end
