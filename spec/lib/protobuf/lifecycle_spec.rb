require 'spec_helper'
require 'protobuf/lifecycle'

describe ::Protobuf::Lifecycle do
  subject { described_class }

  before(:each) do
    described_class.lifecycle_events = {}
  end

  it "registers a string as the event_name" do
    expect {
      subject.register("something") do
        true
      end
    }.to change { subject.lifecycle_events.size }.by(1)
  end

  it "registers a symbol as the event_name" do
    expect {
      subject.register("something") do
        true
      end
    }.to change { subject.lifecycle_events.size }.by(1)
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

  context "normalized event names" do
    specify { subject.normalized_event_name(:derp).should eq("derp") }
    specify { subject.normalized_event_name(:Derp).should eq("derp") }
    specify { subject.normalized_event_name("DERP").should eq("derp") }
    specify { subject.normalized_event_name("derp").should eq("derp") }
  end

end
