module Protobuf
  # Loads service classes from a directory tree so that
  # `Protobuf::Rpc::Service.subclasses` is populated before the RPC server
  # asks for `implemented_services`. Needed because Zeitwerk autoloading is
  # lazy and `subclasses` only returns classes that have been loaded.
  module ServiceLoader
    DEFAULT_GLOB = '**/*_service.rb'.freeze

    def self.load_services(path, glob = DEFAULT_GLOB)
      return [] if path.nil?
      dir = path.to_s
      return [] unless ::File.directory?(dir)

      ::Dir.glob(::File.join(dir, glob)).sort.each do |file|
        load file
      end
    end
  end
end
