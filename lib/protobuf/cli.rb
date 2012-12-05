require 'thor'
require 'protobuf/version'
require 'protobuf/logger'
require 'protobuf/rpc/servers/evented_runner'
require 'protobuf/rpc/servers/socket_runner'
require 'protobuf/rpc/servers/zmq_runner'

module Protobuf
  class CLI < ::Thor
    include ::Thor::Actions

    attr_accessor :runner, :mode, :start_aborted

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
    option :evented,                    :type => :boolean, :aliases => %w(-m), :desc => 'Evented Mode for server and client connections (uses EventMachine).'
    option :zmq,                        :type => :boolean, :aliases => %w(-z), :desc => 'ZeroMQ Socket Mode for server and client connections.'

    option :debug,                      :type => :boolean, :default => false, :aliases => %w(-d), :desc => 'Debug Mode. Override log level to DEBUG.'
    option :gc_pause_request,           :type => :boolean, :default => false, :desc => 'Enable/Disable GC pause during request.'
    option :print_deprecation_warnings, :type => :boolean, :default => nil, :desc => 'Cause use of deprecated fields to be printed or ignored.'

    def start(app_file)
      debug_say 'Configuring the rpc_server process'
      @start_aborted = false

      configure_logger
      configure_traps
      configure_server_mode
      require_protobuf!
      configure_gc
      configure_deprecation_warnings

      run_if_no_abort { require_application!(app_file) }
      run_if_no_abort { configure_process_name(app_file) }
      run_if_no_abort { start_server! }

    rescue => e
      say_and_exit!('ERROR: RPC Server failed to start.', e)
    end

    desc 'version', 'Print ruby and protoc versions and exit.'
    def version
      say "Ruby Protobuf v#{::Protobuf::VERSION}, protoc v#{::Protobuf::PROTOC_VERSION}"
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
        debug_say 'Configuring gc'
        ::Protobuf.gc_pause_server_request = options.gc_pause_request?
      end

      # Setup the protobuf logger.
      def configure_logger
        debug_say 'Configuring logger'
        ::Protobuf::Logger.configure({ :file => options.log || STDOUT,
                                       :level => options.debug? ? ::Logger::DEBUG : options.level })

        # Debug output the server options to the log file.
        ::Protobuf::Logger.debug { 'Debugging options:' }
        ::Protobuf::Logger.debug { options.inspect }
      end

      # Re-write the $0 var to have a nice process name in ps.
      def configure_process_name(app_file)
        debug_say 'Configuring process name'
        $0 = "rpc_server --#{@mode} #{options.host}:#{options.port} #{app_file}"
      end

      # Configure the mode of the server and the runner class.
      def configure_server_mode
        debug_say 'Configuring runner mode'
        if options.zmq? && ! options.evented? && ! options.socket?
          @mode = :zmq
          @runner = ::Protobuf::Rpc::ZmqRunner
        elsif options.evented? && ! options.zmq? && ! options.socket?
          @mode = :evented
          @runner = ::Protobuf::Rpc::EventedRunner
        else
          say 'WARNING: You have provided multiple mode options. Defaulting to socket mode.', :yellow if multi_mode?
          @mode = :socket
          @runner = ::Protobuf::Rpc::SocketRunner
        end
      end

      # Configure signal traps.
      # TODO add signal handling for hot-reloading the application.
      def configure_traps
        debug_say 'Configuring traps'
        [:INT, :QUIT, :TERM].each do |signal|
          debug_say "Registering signal trap for #{signal}", :blue
          trap(signal) do
            ::Protobuf::Logger.info { 'RPC Server shutting down...' }
            @start_aborted = true
            @runner.stop
            ::Protobuf::Logger.info { 'Shutdown complete' }
          end
        end
      end

      # Say something if we're in debug mode.
      def debug_say(message, color = :yellow)
        say(message, color) if options.debug?
      end

      # Internal helper to determine if the modes are multi-set which is not valid.
      def multi_mode?
        (options.zmq? && (options.evented? || options.socket?)) \
          && (options.evented? && (options.evented? || options.socket?)) \
          && (options.zmq? && (options.evented? || options.socket?)) \
      end

      # Require the application file given, exiting if the file doesn't exist.
      def require_application!(app_file)
        debug_say 'Requiring app file'
        require app_file
      rescue LoadError => e
        say_and_exit!("Failed to load application file #{app_file}", e)
      end

      # Loads protobuf in the given mode, exiting if somehow the mode is wrong.
      def require_protobuf!
        require "protobuf/#{@mode}.rb"
      rescue LoadError => e
        puts e.message, *(e.backtrace)
        say_and_exit!("Failed to load protobuf runner #{@mode}", e)
      end

      def run_if_no_abort
        yield unless @start_aborted
      end

      def runner_options
        { :host => options.host,
          :port => options.port,
          :backlog => options.backlog,
          :threshold => options.threshold,
          :threads => options.threads }
      end

      def say_and_exit!(message, exception = nil)
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

      # Start the runner and log the relevant options.
      def start_server!
        debug_say 'Invoking server start'
        @runner.run(runner_options) do
          Protobuf::Logger.info { "pid #{::Process.pid} -- #{@mode} RPC Server listening at #{options.host}:#{options.port}" }
        end
      end

    end

  end
end

