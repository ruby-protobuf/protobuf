module Protobuf
  # Requires every Ruby file below a directory, in sorted order. Protobuf::Railtie
  # uses it when the main autoloader cannot eager-load the services directory
  # (classic autoloader, Zeitwerk < 2.6.2, or a path outside the main loader).
  #
  # It uses `require`, not `load`. Zeitwerk tracks `require` of the files it
  # manages, and a file never executes two times.
  module ServiceLoader
    DEFAULT_GLOB = '**/*.rb'.freeze

    def self.load_services(path, glob = DEFAULT_GLOB)
      return [] if path.nil?
      dir = ::File.expand_path(path.to_s)
      return [] unless ::File.directory?(dir)

      ::Dir.glob(::File.join(dir, glob)).sort.each do |file|
        require file
      end
    end
  end
end
