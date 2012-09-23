module Protobuf
  module Field
    class FieldProxy

      def initialize(message_class, rule, type, name, tag, options)
        @message_class, @rule, @type, @name, @tag, @options =
          message_class, rule, type, name, tag, options
      end

      def ready?
        false
      end

      def setup
        type = typename_to_class(@message_class, @type)
        field_class = \
          if type < Enum
            EnumField
          elsif type < Message
            MessageField
          else
            raise TypeError, type.inspect
          end
        field_class.new(@message_class, @rule, type, @name, @tag, @options)
      end

      private

      def typename_to_class(message_class, type)
        names = type.to_s.split('::').map {|s| Util.camelize(s) }
        outer = message_class.to_s.split('::')
        args = (Object.method(:const_defined?).arity == 1) ? [] : [false]
        while
          mod = outer.empty? ? Object : eval(outer.join('::'))
          mod = names.inject(mod) {|m, s|
            m && m.const_defined?(s, *args) && m.const_get(s)
          }
          break if mod
          raise NameError.new("type not found: #{type}", type) if outer.empty?
          outer.pop
        end
        mod
      end

    end
  end
end
