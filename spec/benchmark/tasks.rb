require 'benchmark'
require 'helper/all'
require 'proto/test_service_impl'

namespace :benchmark do
  include SilentConstants

  def benchmark_wrapper(global_bench = nil)
    if global_bench
      yield global_bench
    else
      Benchmark.bm(10) do |bench|
        yield bench
      end
    end
  end

  def em_client_em_server(global_bench = nil)
    EM.stop if EM.reactor_running?

    EventMachine.fiber_run do 
      StubServer.new do |server|
        client = Spec::Proto::TestService.client(:async => false)

        benchmark_wrapper(global_bench) do |bench|
          bench.report("ES / EC") do 
            (1..1000).each { client.find(:name => "Test Name" * 100, :active => true) }
          end
        end
      end

      EM.stop
    end
  end

  def em_client_sock_server(global_bench = nil)
    EM.stop if EM.reactor_running?

    EventMachine.fiber_run do
      StubServer.new(:server => Protobuf::Rpc::SocketServer, :port => 9399) do |server| 
        client = Spec::Proto::TestService.client(:async => false, :port => 9399)

        benchmark_wrapper(global_bench) do |bench|
          bench.report("SS / EC") do 
            (1..1000).each { client.find(:name => "Test Name" * 100, :active => true) }
          end
        end
      end

      EM.stop
    end
  end

  def sock_client_sock_server(global_bench = nil)
    EM.stop if EM.reactor_running?

    StubServer.new(:server => Protobuf::Rpc::SocketServer, :port => 9399) do |server| 
      with_constants "Protobuf::ConnectorType" => "Socket" do
        client = Spec::Proto::TestService.client(:async => false, :port => 9399)

        benchmark_wrapper(global_bench) do |bench|
          bench.report("SS / SC") do 
            (1..1000).each { client.find(:name => "Test Name" * 100, :active => true) }
          end
        end
      end
    end
  end

  def sock_client_em_server(global_bench = nil)
    EM.stop if EM.reactor_running?
    em_thread = Thread.new { EM.run }
    Thread.pass until EM.reactor_running?

    StubServer.new(:port => 9399) do |server| 
      with_constants "Protobuf::ConnectorType" => "Socket" do
        client = Spec::Proto::TestService.client(:async => false, :port => 9399)

        benchmark_wrapper(global_bench) do |bench|
          bench.report("ES / SC") do 
            (1..1000).each { client.find(:name => "Test Name" * 100, :active => true) }
          end
        end
      end
    end

    EM.stop
    Thread.kill(em_thread) if em_thread
  end

  desc "benchmark EventMachine client with EventMachine server"
  task :em_client_em_server do 
    em_client_em_server
  end

  desc "benchmark EventMachine client with Socket server"
  task :em_client_sock_server do
    em_client_sock_server
  end

  desc "benchmark Socket client with Socket server"
  task :sock_client_sock_server do
    sock_client_sock_server
  end

  desc "benchmark Socket client with EventMachine server"
  task :sock_client_em_server do 
    sock_client_em_server
  end

  desc "benchmark server performance"
  task :servers do 
    Benchmark.bm(10) do |bench|
      em_client_em_server(bench)
      em_client_sock_server(bench)
      sock_client_sock_server(bench)
      sock_client_em_server(bench)
    end
  end
end
