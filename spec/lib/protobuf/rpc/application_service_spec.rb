require 'spec_helper'
require SUPPORT_PATH.join('resource_service')

RSpec.describe Protobuf::Rpc::ApplicationService do
  it 'is a subclass of Protobuf::Rpc::Service' do
    expect(described_class.ancestors).to include(Protobuf::Rpc::Service)
  end

  it 'inherits Service class methods (host, port, configure)' do
    expect(described_class).to respond_to(:host, :port, :configure, :rpc, :rpcs)
  end

  describe 'integration with implemented_services' do
    let!(:app_subclass) do
      Class.new(described_class) do
        def self.name
          'ImplementedAppSubclassService'
        end

        rpc :find, Test::ResourceFindRequest, Test::Resource
        def find; end
      end
    end

    let!(:abstract_subclass) do
      Class.new(described_class) do
        def self.name
          'AbstractAppSubclassService'
        end

        rpc :find, Test::ResourceFindRequest, Test::Resource
        # no #find method defined -> not "implemented"
      end
    end

    after do
      # `descendants` holds these classes until GC, which can run late. Remove
      # the rpc method so other specs do not see this class as implemented.
      app_subclass.send(:remove_method, :find)
    end

    it 'is discovered by Service.implemented_services (descendants traversal)' do
      names = Protobuf::Rpc::Service.implemented_services
      expect(names).to include('ImplementedAppSubclassService')
    end

    it 'omits subclasses with no implemented rpc methods' do
      names = Protobuf::Rpc::Service.implemented_services
      expect(names).not_to include('AbstractAppSubclassService')
    end

    it 'does not list the ApplicationService base itself' do
      names = Protobuf::Rpc::Service.implemented_services
      expect(names).not_to include(described_class.name)
    end
  end
end
