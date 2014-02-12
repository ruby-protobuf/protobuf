module Protobuf
  module Rpc
    class Env < Hash
      # Creates an accessor that simply sets and reads a key in the hash:
      #
      #   class Config < Hash
      #     hash_accessor :app
      #   end
      #
      #   config = Config.new
      #   config.app = Foo
      #   config[:app] #=> Foo
      #
      #   config[:app] = Bar
      #   config.app #=> Bar
      #
      def self.hash_accessor(*names) #:nodoc:
        names.each do |name|
          class_eval <<-METHOD, __FILE__, __LINE__ + 1
            def #{name}
              self['#{name}']
            end

            def #{name}=(value)
              self['#{name}'] = value
            end
          METHOD
        end
      end

      # TODO: Add extra info about the environment (i.e. variables) and other
      # information that might be useful
      hash_accessor :caller,
                    :method_name,
                    :request,
                    :response,
                    :service_name,
                    :stats

      def initialize(env = {})
        merge!(env)
      end
    end
  end
end
