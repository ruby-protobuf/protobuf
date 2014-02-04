require 'spec_helper'
require 'protobuf/lifecycle'

describe ::Protobuf::Lifecycle do
  subject { described_class }

  before(:each) do
    ::ActiveSupport::Notifications.notifier = ::ActiveSupport::Notifications::Fanout.new
  end

  it "registers a string as the event_name" do
    ::ActiveSupport::Notifications.should_receive(:subscribe).with("something")
      subject.register("something") { true }
  end

  it "only registers blocks for event callbacks" do
    expect {
      subject.register("something")
    }.to raise_error( /block/ )
  end

  it "calls the registered block when triggered" do
    this = nil
    subject.register("this") do
      this = "not nil"
    end

    subject.trigger("this")
    this.should_not be_nil
    this.should eq("not nil")
  end

  it "calls multiple registered blocks when triggered" do
    this = nil
    that = nil

    subject.register("this") do
      this = "not nil"
    end

    subject.register("this") do
      that = "not nil"
    end

    subject.trigger("this")
    this.should_not be_nil
    this.should eq("not nil")
    that.should_not be_nil
    that.should eq("not nil")
  end

  context 'when the registered block has arity' do
    context 'and the triggered event does not have args' do
      it 'does not pass the args' do
        outer_bar = nil

        subject.register('foo') do |bar|
          bar.should be_nil
          outer_bar = 'triggered'
        end

        subject.trigger('foo')
        outer_bar.should eq 'triggered'
      end
    end

    context 'and the triggered event has arguments' do
      it 'does not pass the args' do
        outer_bar = nil

        subject.register('foo') do |bar|
          bar.should_not be_nil
          outer_bar = bar
        end

        subject.trigger('foo', 'baz')
        outer_bar.should eq 'baz'
      end
    end
  end

  context "normalized event names" do
    specify { subject.normalized_event_name(:derp).should eq("derp") }
    specify { subject.normalized_event_name(:Derp).should eq("derp") }
    specify { subject.normalized_event_name("DERP").should eq("derp") }
    specify { subject.normalized_event_name("derp").should eq("derp") }
  end

end
