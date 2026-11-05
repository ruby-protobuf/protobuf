require 'rails/railtie'
require 'protobuf/service_loader'

module Protobuf
  # RPC discovery (`Service.implemented_services`) walks `descendants`, which
  # only sees loaded classes, and Zeitwerk loads lazily. This railtie loads the
  # configured services directory one time, when the RPC server is about to
  # bind. Web, console, and test processes never pay that cost.
  #
  # Opt in from config/application.rb:
  #
  #   config.protobuf.services_path = 'app/services/rpc'
  #
  # A relative path resolves against Rails.root.
  class Railtie < ::Rails::Railtie
    config.protobuf = ::ActiveSupport::OrderedOptions.new
    config.protobuf.services_path = nil

    initializer 'protobuf.load_services' do |app|
      ::ActiveSupport::Notifications.subscribe('before_server_bind') do
        ::Protobuf::Railtie.load_services(app)
      end
    end

    def self.services_path(app)
      configured = app.config.protobuf.services_path.to_s
      return if configured.empty?

      ::File.expand_path(configured, app.root.to_s)
    end

    def self.load_services(app)
      path = services_path(app)
      return unless path && ::File.directory?(path)

      loader = ::Rails.autoloaders.main # nil with the classic autoloader
      if loader.respond_to?(:eager_load_dir) # Zeitwerk 2.6.2+
        begin
          return loader.eager_load_dir(path)
        rescue ::Zeitwerk::Error
          # The main autoloader does not manage this path. Fall through.
        end
      end

      ::Protobuf::ServiceLoader.load_services(path)
    end
  end
end
