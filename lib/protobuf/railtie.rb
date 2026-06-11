require 'rails/railtie'
require 'protobuf/service_loader'

module Protobuf
  class Railtie < ::Rails::Railtie
    config.protobuf = ::ActiveSupport::OrderedOptions.new
    config.protobuf.services_path = nil

    initializer 'protobuf.configure_autoload', :before => :set_autoload_paths do |app|
      path = ::Protobuf::Railtie.services_path(app)
      if path && ::File.directory?(path)
        app.config.autoload_paths.delete(path)
        app.config.autoload_once_paths.delete(path)
        app.config.eager_load_paths.delete(path)
      end
    end

    config.to_prepare do
      ::Protobuf::ServiceLoader.load_services(
        ::Protobuf::Railtie.services_path(::Rails.application),
      )
    end

    def self.services_path(app)
      configured = app.config.protobuf.services_path
      configured ? configured.to_s : ::File.join(app.root.to_s, 'app', 'services')
    end
  end
end
