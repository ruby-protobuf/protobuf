require 'benchmark'
require 'protobuf/socket'
require 'support/all'
require 'support/test/resource_service'

begin
  require 'perftools'
rescue LoadError
  $stderr.puts 'perftools must be uncommented in the gemspec before you can run this benchmark task'
  exit(1)
end

# Including a way to turn on debug logger for spec runs
if ENV["DEBUG"]
  puts 'debugging'
  debug_log = File.expand_path('../../../debug_bench.log', __FILE__)
  Protobuf::Logging.initialize_logger(debug_log, ::Logger::DEBUG)
end

namespace :benchmark do

  def benchmark_wrapper(global_bench = nil)
    if global_bench
      yield global_bench
    else
      Benchmark.bm(10) do |bench|
        yield bench
      end
    end
  end

  def sock_client_sock_server(number_tests, test_length, global_bench = nil)
    load "protobuf/socket.rb"

    StubServer.new(:server => Protobuf::Rpc::Socket::Server, :port => 9399) do |server|
      client = ::Test::ResourceService.client(:port => 9399)

      benchmark_wrapper(global_bench) do |bench|
        bench.report("SS / SC") do
          (1..number_tests.to_i).each { client.find(:name => "Test Name" * test_length.to_i, :active => true) }
        end
      end
    end
  end

  def zmq_client_zmq_server(number_tests, test_length, global_bench = nil)
    load "protobuf/zmq.rb"
    StubServer.new(:port => 9399, :server => Protobuf::Rpc::Zmq::Server) do |server|
      client = ::Test::ResourceService.client(:port => 9399)

      benchmark_wrapper(global_bench) do |bench|
        bench.report("ZS / ZC") do
          (1..number_tests.to_i).each { client.find(:name => "Test Name" * test_length.to_i, :active => true) }
        end
      end
      server.stop
    end
  end

  desc "benchmark ZMQ client with ZMQ server"
  task :zmq_client_zmq_server, [:number, :length] do |t, args|
    args.with_defaults(:number => 1000, :length => 100)
    zmq_client_zmq_server(args[:number], args[:length])
  end

  desc "benchmark ZMQ client with ZMQ server and profile"
  task :zmq_profile, [:number, :length, :profile_output] do |t, args|
    args.with_defaults(:number => 1000, :length => 100, :profile_output => "/tmp/zmq_profiler_#{Time.now.to_i}")
    ::PerfTools::CpuProfiler.start(args[:profile_output]) do
      zmq_client_zmq_server(args[:number], args[:length])
    end

    puts args[:profile_output]
  end

  desc "benchmark Protobuf Message #new"
  task :profile_protobuf_new, [:number, :profile_output] do |t, args|
    args.with_defaults(:number => 1000, :profile_output => "/tmp/profiler_new_#{Time.now.to_i}")
    create_params = { :name => "The name that we set", :date_created => Time.now.to_i, :status => 2 }
    ::PerfTools::CpuProfiler.start(args[:profile_output]) do
      args[:number].to_i.times { Test::Resource.new(create_params) }
    end

    puts args[:profile_output]
  end

  desc "benchmark Protobuf Message #serialize"
  task :profile_protobuf_serialize, [:number, :profile_output] do |t, args|
    args.with_defaults(:number => 1000, :profile_output => "/tmp/profiler_new_#{Time.now.to_i}")
    create_params = { :name => "The name that we set", :date_created => Time.now.to_i, :status => 2 }
    ::PerfTools::CpuProfiler.start(args[:profile_output]) do
      args[:number].to_i.times { Test::Resource.new(create_params).serialize }
    end

    puts args[:profile_output]
  end

  desc "benchmark Socket client with Socket server"
  task :sock_client_sock_server, [:number, :length] do |t, args|
    args.with_defaults(:number => 1000, :length => 100)
    sock_client_sock_server(args[:number], args[:length])
  end

  desc "benchmark server performance"
  task :servers, [:number, :length] do |t, args|
    args.with_defaults(:number => 1000, :length => 100)

    Benchmark.bm(10) do |bench|
      zmq_client_zmq_server(args[:number], args[:length], bench)
      sock_client_sock_server(args[:number], args[:length], bench)
    end
  end
end
