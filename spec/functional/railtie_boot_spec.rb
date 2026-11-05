require 'spec_helper'
require 'open3'
require 'rbconfig'
require 'tmpdir'
require 'fileutils'

# Boots a real Rails app in a subprocess, with the load order that the
# `rpc_server` CLI uses: protobuf loads first, then the app file loads Rails.
RSpec.describe 'Protobuf::Railtie in a booted Rails app' do
  let(:lib_dir) { ::File.expand_path('../../../lib', __FILE__) }

  def write(root, relative_path, contents)
    full = ::File.join(root, relative_path)
    ::FileUtils.mkdir_p(::File.dirname(full))
    ::File.write(full, contents)
  end

  def build_app(root, services_path)
    config_line = services_path ? "config.protobuf.services_path = #{services_path.inspect}" : ''

    write(root, 'config/environment.rb', <<-RUBY)
      require 'rails'
      class RailtieBootApp < Rails::Application
        config.root = #{root.inspect}
        config.eager_load = false
        config.logger = Logger.new(nil)
        config.secret_key_base = 'x' * 64
        #{config_line}
      end
      Rails.application.initialize!
    RUBY

    # app/services is a Zeitwerk root, so app/services/rpc/ is the Rpc namespace.
    write(root, 'app/services/rpc/echo_service.rb', <<-RUBY)
      module Rpc
        class EchoService < ::Protobuf::Rpc::ApplicationService
          rpc :echo, ::Protobuf::Socketrpc::Request, ::Protobuf::Socketrpc::Response
          def echo; end
        end
      end
    RUBY

    write(root, 'app/services/plain_object.rb', <<-RUBY)
      class PlainObject
        $stdout.puts 'PLAIN_OBJECT_LOADED'
      end
    RUBY
  end

  def boot(root)
    script = <<-RUBY
      require 'protobuf/socket'
      require #{::File.join(root, 'config/environment').inspect}
      puts "BEFORE_BIND=\#{::Protobuf::Rpc::Service.implemented_services.inspect}"
      ::ActiveSupport::Notifications.instrument('before_server_bind')
      puts "AFTER_BIND=\#{::Protobuf::Rpc::Service.implemented_services.inspect}"
    RUBY

    Open3.capture2e(::RbConfig.ruby, '-I', lib_dir, '-e', script, :chdir => root)
  end

  it 'loads the configured services directory when the server binds' do
    ::Dir.mktmpdir do |root|
      build_app(root, 'app/services/rpc')
      output, status = boot(root)

      expect(status).to be_success, output
      expect(output).to include('BEFORE_BIND=[]')
      expect(output).to include('AFTER_BIND=["Rpc::EchoService"]')
      expect(output).not_to include('PLAIN_OBJECT_LOADED')
    end
  end

  it 'loads nothing when services_path is not configured' do
    ::Dir.mktmpdir do |root|
      build_app(root, nil)
      output, status = boot(root)

      expect(status).to be_success, output
      expect(output).to include('AFTER_BIND=[]')
      expect(output).not_to include('PLAIN_OBJECT_LOADED')
    end
  end
end
