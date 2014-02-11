require 'spec_helper'
require 'protobuf/cli'

describe ::Protobuf::CLI do

  let(:app_file) do
    File.expand_path('../../../support/test_app_file.rb', __FILE__)
  end

  let(:sock_runner) {
    runner = double("SocketRunner", :register_signals => nil)
    runner.stub(:run) { ::ActiveSupport::Notifications.publish( "after_server_bind" ) }
    runner
  }

  let(:zmq_runner) {
    runner = double "ZmqRunner", register_signals: nil
    runner.stub(:run) { ::ActiveSupport::Notifications.publish( "after_server_bind" ) }
    runner
  }

  before(:each) do
    ::Protobuf::Rpc::SocketRunner.stub(:new) { sock_runner }
    ::Protobuf::Rpc::ZmqRunner.stub(:new) { zmq_runner }
  end

  describe '#start' do
    let(:base_args) { [ 'start', app_file ] }
    let(:test_args) { [] }
    let(:args) { base_args + test_args }

    context 'host option' do
      let(:test_args) { [ '--host=123.123.123.123' ] }

      it 'sends the host option to the runner' do
        ::Protobuf::Rpc::SocketRunner.should_receive(:new) do |options|
          options[:host].should eq '123.123.123.123'
        end.and_return(sock_runner)
        described_class.start(args)
      end
    end

    context 'port option' do
      let(:test_args) { [ '--port=12345' ] }

      it 'sends the port option to the runner' do
        ::Protobuf::Rpc::SocketRunner.should_receive(:new) do |options|
          options[:port].should eq 12345
        end.and_return(sock_runner)
        described_class.start(args)
      end
    end

    context 'threads option' do
      let(:test_args) { [ '--threads=500' ] }

      it 'sends the threads option to the runner' do
        ::Protobuf::Rpc::SocketRunner.should_receive(:new) do |options|
          options[:threads].should eq 500
        end.and_return(sock_runner)
        described_class.start(args)
      end
    end

    context 'backlog option' do
      let(:test_args) { [ '--backlog=500' ] }

      it 'sends the backlog option to the runner' do
        ::Protobuf::Rpc::SocketRunner.should_receive(:new) do |options|
          options[:backlog].should eq 500
        end.and_return(sock_runner)
        described_class.start(args)
      end
    end

    context 'threshold option' do
      let(:test_args) { [ '--threshold=500' ] }

      it 'sends the backlog option to the runner' do
        ::Protobuf::Rpc::SocketRunner.should_receive(:new) do |options|
          options[:threshold].should eq 500
        end.and_return(sock_runner)
        described_class.start(args)
      end
    end

    context 'log options' do
      let(:test_args) { [ '--log=mylog.log', '--level=0' ] }

      it 'sends the log file and level options to the runner' do
        ::Protobuf::Logger.should_receive(:configure) do |options|
          options[:file].should eq 'mylog.log'
          options[:level].should eq 0
        end
        described_class.start(args)
      end
    end

    context 'gc options' do

      context 'when gc options are not present' do
        let(:test_args) { [] }

        it 'sets both request and serialization pausing to false' do
          described_class.start(args)
          ::Protobuf.should_not be_gc_pause_server_request
        end
      end

      unless defined?(JRUBY_VERSION)
        context 'request pausing' do
          let(:test_args) { [ '--gc_pause_request' ] }

          it 'sets the configuration option to GC pause server request' do
            described_class.start(args)
            ::Protobuf.should be_gc_pause_server_request
          end
        end
      end
    end

    context 'deprecation options' do
      context 'when not given' do
        let(:test_args) { [] }

        context 'when no ENV is present and no command line option' do
          before { ENV.delete("PB_IGNORE_DEPRECATIONS") }

          it 'sets the deprecation warning flag to true' do
            described_class.start(args)
            ::Protobuf.print_deprecation_warnings?.should be_true
          end
        end

        context 'if ENV["PB_IGNORE_DEPRECATIONS"] is present' do
          before { ENV["PB_IGNORE_DEPRECATIONS"] = "1" }
          after { ENV.delete("PB_IGNORE_DEPRECATIONS") }

          it 'sets the deprecation warning flag to false ' do
            described_class.start(args)
            ::Protobuf.print_deprecation_warnings?.should be_false
          end
        end
      end

      context 'when enabled' do
        let(:test_args) { [ '--print_deprecation_warnings' ] }

        it 'sets the deprecation warning flag to true' do
          described_class.start(args)
          ::Protobuf.print_deprecation_warnings?.should be_true
        end
      end

      context 'when disabled' do
        let(:test_args) { [ '--no-print_deprecation_warnings' ] }

        it 'sets the deprecation warning flag to false' do
          described_class.start(args)
          ::Protobuf.print_deprecation_warnings?.should be_false
        end
      end
    end

    context 'run modes' do

      context 'socket' do
        let(:test_args) { [ '--socket' ] }
        let(:runner) { ::Protobuf::Rpc::SocketRunner }

        before do
          ::Protobuf::Rpc::ZmqRunner.should_not_receive(:new)
        end

        it 'is activated by the --socket switch' do
          runner.should_receive(:new)
          described_class.start(args)
        end

        it 'is activated by PB_SERVER_TYPE=Socket ENV variable' do
          ENV['PB_SERVER_TYPE'] = "Socket"
          runner.should_receive(:new).and_return(sock_runner)
          described_class.start(args)
          ENV.delete('PB_SERVER_TYPE')
        end

        it 'configures the connector type to be socket' do
          load "protobuf/socket.rb"
          ::Protobuf.connector_type.should == :socket
        end
      end

      context 'zmq workers only' do
        let(:test_args) { [ '--workers_only', '--zmq' ] }
        let(:runner) { ::Protobuf::Rpc::ZmqRunner }

        before do
          ::Protobuf::Rpc::SocketRunner.should_not_receive(:new)
        end

        it 'is activated by the --workers_only switch' do
          runner.should_receive(:new) do |options|
            options[:workers_only].should be_true
          end.and_return(zmq_runner)

          described_class.start(args)
        end

        it 'is activated by PB_WORKERS_ONLY=1 ENV variable' do
          ENV['PB_WORKERS_ONLY'] = "1"
          runner.should_receive(:new) do |options|
            options[:workers_only].should be_true
          end.and_return(zmq_runner)

          described_class.start(args)
          ENV.delete('PB_WORKERS_ONLY')
        end
      end

      context 'zmq worker port' do
        let(:test_args) { [ '--worker_port=1234', '--zmq' ] }
        let(:runner) { ::Protobuf::Rpc::ZmqRunner }

        before do
          ::Protobuf::Rpc::SocketRunner.should_not_receive(:new)
        end

        it 'is activated by the --worker_port switch' do
          runner.should_receive(:new) do |options|
            options[:worker_port].should eq(1234)
          end.and_return(zmq_runner)

          described_class.start(args)
        end
      end

      context 'zmq' do
        let(:test_args) { [ '--zmq' ] }
        let(:runner) { ::Protobuf::Rpc::ZmqRunner }

        before do
          ::Protobuf::Rpc::SocketRunner.should_not_receive(:new)
        end

        it 'is activated by the --zmq switch' do
          runner.should_receive(:new)
          described_class.start(args)
        end

        it 'is activated by PB_SERVER_TYPE=Zmq ENV variable' do
          ENV['PB_SERVER_TYPE'] = "Zmq"
          runner.should_receive(:new)
          described_class.start(args)
          ENV.delete('PB_SERVER_TYPE')
        end

        it 'configures the connector type to be zmq' do
          load "protobuf/zmq.rb"
          ::Protobuf.connector_type.should == :zmq
        end
      end

    end

  end

end
