require 'rbconfig'
# # # # # # # # #
# by               Jan Lelis
# e-mail:          mail@janlelis.de
# type/version:    ruby 
# snippet url:     http://rbJL.net/35/os.rb
# original post:   http://rbJL.net/35-how-to-properly-check-for-your-ruby-interpreter-version-and-os
# license:         CC-BY (DE)
#
# (c) 2010 Jan Lelis.

module OS
  class << self
    def is?(what)
      what === RbConfig::CONFIG['host_os']
    end
    alias is is?

    def to_s
      RbConfig::CONFIG['host_os']
    end
  end

  module_function

  def linux?
    OS.is? /linux|cygwin/
  end

  def mac?
    OS.is? /mac|darwin/
  end

  def bsd?
    OS.is? /bsd/
  end

  def windows?
    OS.is? /mswin|win|mingw/
  end

  def solaris?
    OS.is? /solaris|sunos/
  end

  def posix?
    linux? or mac? or bsd? or solaris? or Process.respond_to?(:fork)
  end
end
  
# Bail if windows or no compiler needed
return if ::OS.windows? || ENV['WITHOUT_PROTO_COMPILER']

begin
  require 'mkmf'

  include_directory = File.expand_path(File.join(File.dirname(__FILE__), "..", "protobuf-2.4.1", "src"))

  $CPPFLAGS << " -I#{include_directory}"
  $CPPFLAGS << " -Wall "

  have_library("pthread")
  have_library("protoc")
  have_library("protobuf")

  create_makefile('ruby_generator')
rescue 
  $stdout << <<-WARNING
    Cannot compile native extension.

    If you are running on Jruby or Windows you should compile protocol buffer
    definitions on another computer and then use those definitions locally.

    Only the compiler is restricted by this.  The definitions should work without issue.
  WARNING
  $stdout << $/
end
