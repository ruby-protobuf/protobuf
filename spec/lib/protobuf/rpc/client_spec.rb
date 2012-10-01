require 'spec_helper'
require 'spec/proto/test_service_impl'

describe Protobuf::Rpc::Client do
  before(:each) do
    load 'protobuf/evented.rb'
    ::Protobuf::Rpc::Connector.connector_for_client(true)
    ::Spec::Proto::TestService.configure(::Spec::Proto::TestService::DEFAULT_LOCATION)
  end

  context "when using fiber based calls" do
    it "waits for response when running synchronously" do
      EventMachine.fiber_run do
        StubServer.new(:delay => 3) do |server|
          client = Spec::Proto::TestService.client(:async => false)
          start = now

          client.find(:name => "Test Name", :active => true) do |c|
            c.on_success do |succ|
              succ.name.should eq("Test Name")
              succ.status.should eq(Spec::Proto::StatusType::ENABLED)
            end

            c.on_failure do |err|
              raise err.inspect
            end
          end

          (now - start).should be_within(server.options.delay * 0.10).of(server.options.delay)
        end

        EM.stop
      end
    end

    it "doesn't wait for response when running async call inside fiber" do
      EventMachine.fiber_run do
        StubServer.new(:delay => 3) do |server|
          client = Spec::Proto::TestService.client(:async => true)
          start = now
          client.find(:name => "Test Name", :active => true)

          (now - start).should_not be_within(server.options.delay* 0.10).of(server.options.delay)
        end
        EM.stop
      end
    end

    it "throws and error when synchronous code is attempted without 'EventMachine.fiber_run'" do
      subject = Proc.new do
        EventMachine.run do
          StubServer.new(:delay => 1) do |server|
            client = Spec::Proto::TestService.client(:async => false)
            client.find(:name => "Test Name", :active => true)
          end
        end
      end

      subject.should raise_error(RuntimeError, /EM.fiber_run/)
    end

    it "throws a timeout when client timeout is exceeded" do
      error = nil
      test_proc = Proc.new do
        EventMachine.fiber_run do
          StubServer.new(:delay => 2) do |server|
            client = Spec::Proto::TestService.client(:async => false, :timeout => 1)
            client.find(:name => "Test Name", :active => true) do |cl|
              cl.on_success {}
              cl.on_failure {|f| error = f}
            end
          end
          EM.stop
        end
      end

      test_proc.call
      error.message.should =~ /timeout/i
    end

    context "without reactor_running?" do

      it "throws a timeout when client timeout is exceeded" do
        subject = Proc.new do
          StubServer.new(:delay => 2) do |server|
            client = Spec::Proto::TestService.client(:async => false, :timeout => 1)
            client.find(:name => "Test Name", :active => true)
          end
        end

        subject.should raise_error(RuntimeError, /timeout/i)
      end

      it "calls failure_cb & throws a timeout when client timeout is exceeded" do
        failure_message = nil

        subject = Proc.new do
          StubServer.new(:delay => 2) do |server|
            client = Spec::Proto::TestService.client(:async => false, :timeout => 1)
            client.find(:name => "Test Name", :active => true) do |c|
              c.on_failure do |f|
                failure_message = f.message
              end
            end
          end
        end

        subject.call
        failure_message.should match(/timeout/)
      end

    end

  end

  context 'when creating a client from a service' do

    it 'should be able to get a client through the Service#client helper method' do
      Spec::Proto::TestService.client(:port => 9191).should eq(Protobuf::Rpc::Client.new(:service => Spec::Proto::TestService, :port => 9191))
    end

    it "should be able to override a service location's host and port" do
      Spec::Proto::TestService.located_at 'somewheregreat.com:12345'
      clean_client = Spec::Proto::TestService.client
      clean_client.options[:host].should eq('somewheregreat.com')
      clean_client.options[:port].should eq(12345)

      updated_client = Spec::Proto::TestService.client(:host => 'amazing.com', :port => 54321)
      updated_client.options[:host].should eq('amazing.com')
      updated_client.options[:port].should eq(54321)
    end

    it 'should be able to define the syncronicity of the client request' do
      client = Spec::Proto::TestService.client(:async => false)
      client.options[:async].should be_false
      client.async?.should be_false

      client = Spec::Proto::TestService.client(:async => true)
      client.options[:async].should be_true
      client.async?.should be_true
    end

    it 'should be able to define which service to create itself for' do
      client = Protobuf::Rpc::Client.new :service => Spec::Proto::TestService
      client.options[:service].should eq(Spec::Proto::TestService)
    end

    it 'should have a hard default for host and port on a service that has not been configured' do
      reset_service_location Spec::Proto::TestService
      client = Spec::Proto::TestService.client
      client.options[:host].should eq(Protobuf::Rpc::Service::DEFAULT_LOCATION[:host])
      client.options[:port].should eq(Protobuf::Rpc::Service::DEFAULT_LOCATION[:port])
    end

  end

  context 'when calling methods on a service client' do

    # NOTE: we are assuming the service methods are accurately
    # defined inside spec/proto/test_service.rb,
    # namely the :find method

    it 'should respond to defined service methods' do
      client = Spec::Proto::TestService.client
      client.should_receive(:send_request).and_return(nil)
      expect { client.find(nil) }.to_not raise_error
    end

    it 'raises a NameError when accessing a var that does not exist' do
      pending
    end

    it 'should be able to set and get local variables within client response blocks' do
      outer_value = 'OUTER'
      inner_value = 'INNER'
      client = Spec::Proto::TestService.client(:async => true)

      EM.should_receive(:reactor_running?).and_return(true)
      EM.stub!(:next_tick) do
        client.success_cb.call(inner_value)
      end

      client.find(nil) do |c|
        c.on_success do |response|
          outer_value.should eq('OUTER')
          outer_value = response
        end
      end
      outer_value.should eq(inner_value)
    end

  end

  context 'when receiving request objects' do

    it 'should be able to create the correct request object if passed a hash' do
      client = Spec::Proto::TestService.client
      client.should_receive(:send_request)
      client.find({:name => 'Test Name', :active => false})
      client.options[:request].should be_a(Spec::Proto::ResourceFindRequest)
      client.options[:request].name.should eq('Test Name')
      client.options[:request].active.should eq(false)
    end

  end

end
