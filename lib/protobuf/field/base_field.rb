require 'protobuf/common/wire_type'
require 'protobuf/field/field_array'

module Protobuf
  module Field
    class BaseField
      ##
      # Attributes
      #
      attr_reader :message_class, :rule, :type, :name, :tag, :default, :default_value, :setter_method_name, :getter_method_name
      
      ##
      # Class Methods
      #
      def self.default
        nil
      end

      ##
      # Constructor
      #
      def initialize(message_class, rule, type, name, tag, options)
        @message_class, @rule, @type, @name, @tag = \
          message_class, rule, type, name, tag

        @getter_method_name = name
        @setter_method_name = "#{name}=".to_sym
        @default   = options.delete(:default)
        @extension = options.delete(:extension)
        @packed    = repeated? && options.delete(:packed)
        unless options.empty?
          warn "WARNING: Invalid options: #{options.inspect} (in #{@message_class.name.split('::').last}.#{@name})"
        end

        if packed? && ! [WireType::VARINT, WireType::FIXED32, WireType::FIXED64].include?(wire_type)
          raise "Can't use packed encoding for `#{@type}' type"
        end

        @default_value = \
          case @rule
          when :repeated then
            FieldArray.new(self).freeze
          when :required then
            nil
          when :optional then
            typed_default_value
          end

        define_accessor
      end

      ##
      # Public Instance Methods
      #
      def acceptable?(value)
        true
      end

      def enum?
        return @_enum unless @_enum.nil?
        @_enum = (self.class < ::Protobuf::Field::EnumField)
      end

      def message?
        return @_message unless @_message.nil?
        @_message = (self.class < ::Protobuf::Field::MessageField)
      end

      def initialized?(message_instance)
        value = message_instance.__send__(getter_method_name)
        case @rule
        when :required then
          ! value.nil? && (! kind_of?(MessageField) || value.initialized?)
        when :repeated then
          value.all? {|msg| ! kind_of?(MessageField) || msg.initialized? }
        when :optional then
          value.nil? || ! kind_of?(MessageField) || value.initialized?
        end
      end

      # Decode +bytes+ and pass to +message_instance+.
      def set(message_instance, bytes)
        if packed?
          array = message_instance.__send__(getter_method_name)
          method = \
            case wire_type
            when WireType::FIXED32 then :read_fixed32
            when WireType::FIXED64 then :read_fixed64
            when WireType::VARINT  then :read_varint
            end
          stream = StringIO.new(bytes)
          until stream.eof?
            array << decode(Decoder.__send__(method, stream))
          end
        else
          value = decode(bytes)
          if repeated?
            message_instance.__send__(getter_method_name) << value
          else
            message_instance.__send__(setter_method_name, value)
          end
        end
      end

      # Decode +bytes+ and return a field value.
      def decode(bytes)
        raise NotImplementedError, "#{self.class.name}\#decode"
      end

      # Encode +value+ and return a byte string.
      def encode(value)
        raise NotImplementedError, "#{self.class.name}\#encode"
      end

      def extension?
        !!@extension
      end

      # Is this a repeated field?
      def repeated?
        return @_repeated unless @_repeated.nil?
        @_repeated = (@rule == :repeated)
      end

      # Is this a required field?
      def required?
        return @_required unless @_required.nil?
        @_required = (@rule == :required)
      end

      # Is this a optional field?
      def optional?
        return @_optional unless @_optional.nil?
        @_optional = (@rule == :optional)
      end

      # Is this a packed repeated field?
      def packed?
        !!@packed
      end

      # Upper limit for this field.
      def max
        self.class.max
      end

      # Lower limit for this field.
      def min
        self.class.min
      end

      def to_s
        "#{@rule} #{@type} #{@name} = #{@tag} #{@default ? "[default=#{@default.inspect}]" : ''}"
      end

      private

      ## 
      # Private Instance Methods
      #
      def define_accessor
        define_getter
        if repeated?
          define_array_setter
        else
          define_setter
        end
      end

      def define_array_setter
        field = self
        @message_class.class_eval do
          define_method(field.setter_method_name) do |val|
            @values[field.name].replace(val)
          end
        end
      end

      def define_getter
        field = self
        @message_class.class_eval do
          define_method(field.getter_method_name) do
            @values.fetch(field.name, field.default_value)
          end
        end
      end

      def define_setter
        field = self
        @message_class.class_eval do
          define_method(field.setter_method_name) do |val|
            if val.nil?
              @values.delete(field.name)
            elsif field.acceptable?(val)
              @values[field.name] = val
            end
          end
        end
      end

      def typed_default_value
        if @default.nil?
          self.class.default
        else
          @default
        end
      end
    end 
  end
end
