# # # # # # # # #
# by               Jan Lelis
# e-mail:          mail@janlelis.de
# type/version:    ruby 
# snippet url:     http://rbJL.net/35/os.rb
# original post:   http://rbJL.net/35-how-to-properly-check-for-your-ruby-interpreter-version-and-os
# license:         CC-BY (DE)
#
# (c) 2010 Jan Lelis.

require 'rbconfig'
module RubyEngine
  class << self
    # try to guess it
    @interpreter = case
    when RUBY_PLATFORM == 'parrot'
      'cardinal'
    when Object.constants.include?( :RUBY_ENGINE ) ||
         Object.constants.include?( 'RUBY_ENGINE'  )
      if RUBY_ENGINE == 'ruby'
        if RUBY_DESCRIPTION =~ /Enterprise/
          'ree'
        else
          'mri'
        end
      else
        RUBY_ENGINE.to_s # jruby, rbx, ironruby, macruby, etc.
      end
    else # probably 1.8
      'mri'
    end

    def is?(what)
      what === @interpreter
    end
    alias is is?

    def to_s
      @interpreter
    end
  end

module_function

  def mri?
    RubyEngine.is? 'mri'
  end
  alias official_ruby? mri?
  alias ruby? mri?

  def jruby?
    RubyEngine.is? 'jruby'
  end
  alias java? jruby?

  def rubinius?
    RubyEngine.is? 'rbx'
  end
  alias rbx? rubinius?

  def ree?
    RubyEngine.is? 'ree'
  end
  alias enterprise? ree?

  def ironruby?
    RubyEngine.is? 'ironruby'
  end
  alias iron_ruby? ironruby?

  def cardinal?
    RubyEngine.is? 'cardinal'
  end
  alias parrot? cardinal?
  alias perl? cardinal?
end

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

# Bail if windows or jruby or no compiler needed
return if (OS.windows? || RubyEngine.jruby? || ENV['WITHOUT_PROTO_COMPILER'])

require 'mkmf'

include_directory = File.join(File.expand_path(File.dirname(__FILE__)), "..", "protobuf-2.4.1", "src")

$CPPFLAGS << " -I#{include_directory}"
$CPPFLAGS << " -Wall "

have_library("pthread")
have_library("protoc")
have_library("protobuf")

create_makefile('ruby_generator')
