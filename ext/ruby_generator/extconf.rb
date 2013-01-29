unless defined?(JRUBY_VERSION)
  begin
    require 'mkmf'
    include_directory = File.expand_path(ENV['PROTOC_SRC'] || File.join(File.dirname(__FILE__), "..", "protobuf-2.4.1", "src"))

    $CPPFLAGS << " -I#{include_directory}"
    $CPPFLAGS << " -Wall "

    have_library("pthread")
    have_library("protoc")
    have_library("protobuf")

    create_makefile('ruby_generator')
  rescue ::Gem::Installer::ExtensionBuildError => ex
    $stdout << <<-WARNING
      Cannot compile native extension.

      If you are running on Jruby or Windows you should compile protocol buffer
      definitions on another computer and then use those definitions locally.

      Only the compiler is restricted by this.  The definitions should work without issue.
    WARNING
    $stdout << $/
  end
else
  $stdout << <<-WARNING
    Cannot compile native extension.

    If you are running on Jruby or Windows you should compile protocol buffer
    definitions on another computer and then use those definitions locally.

    Only the compiler is restricted by this.  The definitions should work without issue.
  WARNING
  $stdout << $/
end
