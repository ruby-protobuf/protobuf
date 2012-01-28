require 'benchmark'
require 'helper/all'
require 'proto/test_service_impl'

namespace :benchmark do
  include SilentConstants

  task :em_client_em_server do 
    EventMachine.fiber_run do 
      StubServer.new do |server|
        Benchmark.bm(7) do |bench|
          bench.report("EM S / EM C") do 
            client = Spec::Proto::TestService.client(:async => false)
            (1..1000).each { client.find(:name => "Test Name" * 100, :active => true) }
          end
        end
      end

      EM.stop
    end
  end

  task :sock_client_em_server do
    #    server = OpenStruct.new(:server => "127.0.0.1", :port => 9399, :backlog => 100, :threshold => 100)
    #    @server_thread = Thread.new(server) { |s| Protobuf::Rpc::SocketRunner.run(s) }
    #    Thread.pass until Protobuf::Rpc::SocketServer.running?

    Benchmark.bm(7) do |bench|
      bench.report("S S / EM C") do 
        EventMachine.fiber_run do
          client = Spec::Proto::TestService.client(:async => false, :port => 9399)
          (1..1000).each { client.find(:name => "Test Name", :active => true) }
          EM.stop
        end
      end
    end

    #    Protobuf::Rpc::SocketRunner.stop
    #    Thread.kill(@server_thread)
  end

  task :sock_client_sock_server do
# server = OpenStruct.new(:server => "127.0.0.1", :port => 9399, :backlog => 100, :threshold => 100)
#        @server_thread = Thread.new(server) { |s| Protobuf::Rpc::SocketRunner.run(s) }
#        Thread.pass until Protobuf::Rpc::SocketServer.running?

    StubServer.new(:server => Protobuf::Rpc::SocketServer, :port => 9399) do |server| 
      $stdout << server.inspect
      Benchmark.bm(7) do |bench|
        bench.report("SS / SC") do 
          with_constants "Protobuf::ConnectorType" => "Socket" do
            client = Spec::Proto::TestService.client(:async => false, :port => 9399)
            $stdout << client.inspect << $\
            (1..1000).each { client.find(:name => "Test Name" * 100, :active => true) }
          end
        end
      end
    end

#        Protobuf::Rpc::SocketRunner.stop
#        Thread.kill(@server_thread)
  end

  desc "output server performance"
  task :servers => [:sock_client_sock_server, :em_client_em_server, :sock_client_em_server]
end
