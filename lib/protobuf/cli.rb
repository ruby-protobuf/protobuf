require 'thor'
require 'protobuf/version'
require 'protobuf/logger'
require 'protobuf/rpc/servers/socket_runner'
require 'protobuf/rpc/servers/zmq_runner'

module Protobuf
  class CLI < ::Thor
    include ::Thor::Actions

    attr_accessor :runner, :mode

    default_task :start

    desc 'start APP_FILE', 'Run the RPC server in the given mode, preloading the given APP_FILE. This is the default task.'

    option :host,                       :type => :string, :default => '127.0.0.1', :aliases => %w(-o), :desc => 'Host to bind.'
    option :port,                       :type => :numeric, :default => 9399, :aliases => %w(-p), :desc => 'Master Port to bind.'

    option :backlog,                    :type => :numeric, :default => 100, :aliases => %w(-b), :desc => 'Backlog for listening socket when using Socket Server.'
    option :threshold,                  :type => :numeric, :default => 100, :aliases => %w(-t), :desc => 'Multi-threaded Socket Server cleanup threshold.'
    option :threads,                    :type => :numeric, :default => 5, :aliases => %w(-r), :desc => 'Number of worker threads to run. Only applicable in --zmq mode.'

    option :log,                        :type => :string, :aliases => %w(-l), :desc => 'Log file or device. Default is STDOUT.'
    option :level,                      :type => :numeric, :default => ::Logger::INFO, :aliases => %w(-v), :desc => 'Log level to use, 0-5 (see http://www.ruby-doc.org/stdlib/libdoc/logger/rdoc/)'

    option :socket,                     :type => :boolean, :aliases => %w(-s), :desc => 'Socket Mode for server and client connections.'
    option :zmq,                        :type => :boolean, :aliases => %w(-z), :desc => 'ZeroMQ Socket Mode for server and client connections.'

    option :beacon_interval,            :type => :numeric, :desc => 'Broadcast beacons every N seconds. (default: 5)'
    option :beacon_port,                :type => :numeric, :desc => 'Broadcast beacons to this port (default: value of ServiceDirectory.port)'
    option :broadcast_beacons,          :type => :boolean, :desc => 'Broadcast beacons for dynamic discovery (Currently only available with ZeroMQ).'
    option :debug,                      :type => :boolean, :default => false, :aliases => %w(-d), :desc => 'Debug Mode. Override log level to DEBUG.'
    option :gc_pause_request,           :type => :boolean, :default => false, :desc => 'Enable/Disable GC pause during request.'
    option :print_deprecation_warnings, :type => :boolean, :default => nil, :desc => 'Cause use of deprecated fields to be printed or ignored.'
    option :workers_only,               :type => :boolean, :default => false, :desc => "Starts process with only workers (no broker/frontend is started) only relevant for Zmq Server"
    option :worker_port,                :type => :numeric, :default => nil, :desc => "Port for 'backend' where workers connect (defaults to port + 1)"

    def start(app_file)
      debug_say('Configuring the rpc_server process')

      configure_logger
      configure_traps
      configure_runner_mode
      create_runner
      configure_process_name(app_file)
      configure_gc
      configure_deprecation_warnings

      require_application(app_file) unless exit_requested?
      start_server unless exit_requested?
    rescue => e
      say_and_exit('ERROR: RPC Server failed to start.', e)
    end

    desc 'version', 'Print ruby and protoc versions and exit.'
    def version
      say("Ruby Protobuf v#{::Protobuf::VERSION}, protoc v#{::Protobuf::PROTOC_VERSION}")
    end

    no_tasks do

      # Tell protobuf how to handle the printing of deprecated field usage.
      def configure_deprecation_warnings
        if options.print_deprecation_warnings.nil?
          ::Protobuf.print_deprecation_warnings = !ENV.key?("PB_IGNORE_DEPRECATIONS")
        else
          ::Protobuf.print_deprecation_warnings = options.print_deprecation_warnings?
        end
      end

      # If we pause during request we don't need to pause in serialization
      def configure_gc
        debug_say('Configuring gc')

        if defined?(JRUBY_VERSION)
          # GC.enable/disable are noop's on Jruby
          ::Protobuf.gc_pause_server_request = false
        else
          ::Protobuf.gc_pause_server_request = options.gc_pause_request?
        end
      end

      # Setup the protobuf logger.
      def configure_logger
        debug_say('Configuring logger')
        ::Protobuf::Logger.configure({ :file => options.log || STDOUT,
                                     :level => options.debug? ? ::Logger::DEBUG : options.level })

        # Debug output the server options to the log file.
        ::Protobuf::Logger.debug { 'Debugging options:' }
        ::Protobuf::Logger.debug { options.inspect }
      end

      # Re-write the $0 var to have a nice process name in ps.
      def configure_process_name(app_file)
        debug_say('Configuring process name')
        $0 = "rpc_server --#{@runner_mode} #{options.host}:#{options.port} #{app_file}"
      end

      # Configure the mode of the server and the runner class.
      def configure_runner_mode
        debug_say('Configuring runner mode')

        if multi_mode?
          say('WARNING: You have provided multiple mode options. Defaulting to socket mode.', :yellow)
          @runner_mode = :socket
        elsif options.zmq?
          @runner_mode = :zmq
        else
          case server_type = ENV["PB_SERVER_TYPE"]
          when nil, /socket/i
            @runner_mode = :socket
          when /zmq/i
            @runner_mode = :zmq
          else
            say "WARNING: You have provided incorrect option 'PB_SERVER_TYPE=#{server_type}'. Defaulting to socket mode.", :yellow
            @runner_mode = :socket
          end
        end
      end

      # Configure signal traps.
      # TODO add signal handling for hot-reloading the application.
      def configure_traps
        debug_say('Configuring traps')

        exit_signals = [:INT, :TERM]
        exit_signals << :QUIT unless defined?(JRUBY_VERSION)

        exit_signals.each do |signal|
          debug_say("Registering trap for exit signal #{signal}", :blue)

          trap(signal) do
            @exit_requested = true
            shutdown_server
          end
        end
      end

      # Create the runner for the configured mode
      def create_runner
        debug_say("Creating #{@runner_mode} runner")
        @runner = case @runner_mode
                  when :zmq
                    create_zmq_runner
                  when :socket
                    create_socket_runner
                  else
                    say_and_exit("Unknown runner mode: #{@runner_mode}")
                  end
      end

      # Say something if we're in debug mode.
      def debug_say(message, color = :yellow)
        say(message, color) if options.debug?
      end

      def exit_requested?
        !!@exit_requested
      end

      # Internal helper to determine if the modes are multi-set which is not valid.
      def multi_mode?
        options.zmq? && options.socket?
      end

      # Require the application file given, exiting if the file doesn't exist.
      def require_application(app_file)
        debug_say('Requiring app file')
        require app_file
      rescue LoadError => e
        say_and_exit("Failed to load application file #{app_file}", e)
      end

      def runner_options
        # Symbolize keys
        opt = options.inject({}) { |h, (k, v)| h[k.to_sym] = v; h }

        opt[:workers_only] = (!!ENV['PB_WORKERS_ONLY']) || options.workers_only

        opt
      end

      def say_and_exit(message, exception = nil)
        message = set_color(message, :red) if ::Protobuf::Logger.file == STDOUT

        ::Protobuf::Logger.error { message }
        if exception
          $stderr.puts "[#{exception.class.name}] #{exception.message}"
          $stderr.puts exception.backtrace.join("\n")

          ::Protobuf::Logger.error { "[#{exception.class.name}] #{exception.message}" }
          ::Protobuf::Logger.debug { exception.backtrace.join("\n") }
        end

        exit(1)
      end

      def create_socket_runner
        require 'protobuf/socket'

        @runner = ::Protobuf::Rpc::SocketRunner.new(runner_options)
      end

      def create_zmq_runner
        require 'protobuf/zmq'

        @runner = ::Protobuf::Rpc::ZmqRunner.new(runner_options)
      end

      def shutdown_server
        ::Protobuf::Logger.info { 'RPC Server shutting down...' }
        @runner.try(:stop)
        ::Protobuf::Rpc::ServiceDirectory.instance.stop
        ::Protobuf::Logger.info { 'Shutdown complete' }
      end

      # Start the runner and log the relevant options.
      def start_server
        debug_say('Running server')

        @runner.run do
          ::Protobuf::Logger.info {
            "pid #{::Process.pid} -- #{@runner_mode} RPC Server listening at #{options.host}:#{options.port}"
          }

          ::ActiveSupport::Notifications.instrument("after_server_bind")
        end
      end
    end
  end
end
