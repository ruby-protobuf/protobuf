unless defined?(JRUBY_VERSION)
  begin
    require 'mkmf'
    src_241 = File.expand_path(File.join('..', '..', 'protobuf-2.4.1', 'src'), __FILE__)
    src_250 = File.expand_path(File.join('..', '..', 'protobuf-2.5.0', 'src'), __FILE__)

    include_directory = case
                        when ENV.key?('PROTOC_SRC') then
                          src_custom = File.expand_path(ENV['PROTOC_SRC'])
                          if File.exist?(src_custom)
                            $stdout << "Compiling from custom source at #{src_custom}"
                            $stdout << $/
                            src_custom
                          else
                            abort <<-ABORT_ERROR

ERROR
  Custom src directory does not exist:

    PROTOC_SRC=#{src_custom}

  Please ensure you are providing an absolute path
  to the custom protobuf src directory.

                            ABORT_ERROR
                            exit 1
                          end
                        when ENV['PROTOC_VERSION'] == '250' then
                          $stdout << "Compiling with protobuf v2.5.0"
                          $stdout << $/
                          src_250
                        else
                          $stdout << "Compiling with protobuf v2.4.1"
                          $stdout << $/
                          src_241
                        end

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

Only the compiler is restricted by this. Previously compiled definitions should work without issue.
    WARNING
    $stdout << $/
  end
else
  $stdout << <<-WARNING
Cannot compile native extension.

If you are running on Jruby or Windows you should compile protocol buffer
definitions on another computer and then use those definitions locally.

Only the compiler is restricted by this. Previously compiled definitions should work without issue.
  WARNING
  $stdout << $/
end
