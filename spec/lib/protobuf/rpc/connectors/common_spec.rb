require 'spec_helper' 
require 'protobuf/rpc/service' 

describe Protobuf::Rpc::Connectors::Common do
  let(:common_class) do 
    Class.new(Protobuf::Rpc::Connectors::Base) do
      include Protobuf::Rpc::Connectors::Common 
      include Eventually
      enable_strict!
      emits :success, :arity => 1
      emits :failure, :arity => 1
      emits :complete, :arity => 1
      
      attr_accessor :options
      attr_accessor :stats
    end
  end

  subject{ @subject ||= common_class.new({}) }

  context "API" do 
    specify{ subject.respond_to?(:any_callbacks?).should be_true }
    specify{ subject.respond_to?(:data_callback).should be_true }
    specify{ subject.respond_to?(:succeed).should be_true }
    specify{ subject.respond_to?(:fail).should be_true }
    specify{ subject.respond_to?(:complete).should be_true }
    specify{ subject.respond_to?(:parse_response).should be_true }
    specify{ subject.respond_to?(:_send_request).should be_true }
    specify{ subject.respond_to?(:verify_options).should be_true }
    specify{ subject.respond_to?(:verify_callbacks).should be_true }
  end

  context "#any_callbacks?" do 

    [:complete, :success, :failure].each do |cb|
      it "returns true if #{cb} event is being listened for" do 
        subject.on(cb, lambda{|p|})
        subject.any_callbacks?.should be_true
      end
    end

    it "returns false when all callbacks are not provided" do 
      subject.num_listeners.should eq 0
      subject.any_callbacks?.should be_false
    end

  end

  context "#data_callback" do 
    it "changes state to use the data callback" do
      subject.data_callback("data")
      subject.instance_variable_get(:@used_data_callback).should be_true
    end

    it "sets the data var when using the data_callback" do 
      subject.data_callback("data")
      subject.instance_variable_get(:@data).should eq("data")
    end
  end

  context "#verify_callbacks" do 

    it "registers data_callback as :failure listener when no listeners are registered" do 
      subject.verify_callbacks
      subject.listeners(:failure).should eq([subject.method(:data_callback)])
    end

    it "registers data_callback as :success listener when no listeners are registered" do 
      subject.verify_callbacks
      subject.listeners(:success).should eq([subject.method(:data_callback)])
    end

    it "doesn't register data_callback as :failure listener when any listeners are registered" do 
      set_cb = lambda{|v| true }
      subject.on(:failure, set_cb)
      subject.verify_callbacks
      subject.listeners(:failure).should eq([set_cb])
      subject.listeners(:failure).should_not include(subject.method(:data_callback))
    end

    it "doesn't register data_callback as :success listener when any listeners are registered" do 
      set_cb = lambda{|v| true }
      subject.on(:success, set_cb)
      subject.verify_callbacks
      subject.listeners(:success).should eq([set_cb])
      subject.listeners(:success).should_not include(subject.method(:data_callback))
    end

  end

  shared_examples "a ConnectorDisposition" do |meth, events, args=nil, emitted=nil|
    
    before(:each) do
      stats = double("Object")
      stats.stub(:end) { true }
      stats.stub(:log_stats) { true }
      subject.stats = stats
    end

    context "when invoking the #{meth} method" do
      it "emits the #{events.join(",")} event(s)" do 
        events.each do |event|
          cb = lambda{|v| }
          expected_cb_args = event == :complete ? subject : emitted
          cb.should_receive(:call).with(*expected_cb_args).and_return(true)
          subject.on(event, cb)
        end
        
        if meth == :complete
          subject.__send__(meth)
        else
          subject.method(meth).call(*args)
        end
      end
    end
  end
  
  context 'event cascade' do
    it_behaves_like("a ConnectorDisposition", :fail, [:failure, :complete], [1, "hi"], [Protobuf::Rpc::Connectors::Common::ClientError.new(1,"hi")])
    it_behaves_like("a ConnectorDisposition", :succeed, [:success, :complete], ["response"], ["response"])
    it_behaves_like("a ConnectorDisposition", :complete, [:complete])
  end
end
