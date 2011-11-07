class Protobuf::ProtoParser
rule
  proto : proto_item
          { result = Protobuf::Node::ProtoNode.new(val) }
        | proto proto_item
          { result.children << val[1] if val[1]}

  proto_item : message
             | extend
             | enum
             | import
             | package
             | option
             | service
             | ';'      { result = nil }

  import : 'import' STRING_LITERAL ';'
           { result = Protobuf::Node::ImportNode.new(val[1]) }

  package : 'package' IDENT dot_ident_list ';'
            { result = Protobuf::Node::PackageNode.new(val[2].unshift(val[1])) }

  dot_ident_list :
                   { result = [] }
                 | dot_ident_list '.' IDENT
                   { result << val[2] }

  option : 'option' option_body ';'
           { result = Protobuf::Node::OptionNode.new(*val[1]) }

  option_body : IDENT dot_ident_list '=' constant
                { result = [val[1].unshift(val[0]), val[3]] }

  message : 'message' IDENT message_body
            { result = Protobuf::Node::MessageNode.new(val[1], val[2]) }

  extend : 'extend' user_type '{' extend_body_list '}'
           { result = Protobuf::Node::ExtendNode.new(val[1], val[3]) }

  extend_body_list :
                     { result = [] }
                   | extend_body_list extend_body
                     { result << val[1] if val[1] }

  extend_body : field
              | group
              | ';'    { result = nil }

  enum : 'enum' IDENT '{' enum_body_list '}'
         { result = Protobuf::Node::EnumNode.new(val[1], val[3]) }

  enum_body_list :
                   { result = [] }
                 | enum_body_list enum_body
                   { result << val[1] if val[1] }

  enum_body : option
            | enum_field
            | ';'         { result = nil }

  enum_field : IDENT '=' integer_literal ';'
               { result = Protobuf::Node::EnumFieldNode.new(val[0], val[2]) }

  service : 'service' IDENT '{' service_body_list '}'
            { result = Protobuf::Node::ServiceNode.new(val[1], val[3]) }

  service_body_list :
                      { result = [] }
                    | service_body_list service_body
                      { result << val[1] if val[1] }

  service_body : option
               | rpc
               | ';'     { result = nil}

  rpc : 'rpc' IDENT '(' rpc_arg ')' 'returns' '(' rpc_arg ')' ';'
        { result = Protobuf::Node::RpcNode.new(val[1], val[3], val[7]) }

  rpc_arg :
          | user_type

  message_body : '{' message_body_body_list '}'
                 { result = val[1] }

  message_body_body_list :
                           { result = [] }
                         | message_body_body_list message_body_body
                           { result << val[1] if val[1] }

  message_body_body : field
                    | enum
                    | message
                    | extend
                    | extensions
                    | group
                    | option
                    | ';'        { result = nil }

  group : label 'group' CAMEL_IDENT '=' integer_literal message_body
          { result = Protobuf::Node::GroupNode.new(val[0], val[2], val[4], val[5]) }

  field : label type field_name '=' integer_literal ';'
          { result = Protobuf::Node::FieldNode.new(val[0], val[1], val[2], val[4]) }
        | label type field_name '=' integer_literal '[' field_option_list ']' ';'
          { result = Protobuf::Node::FieldNode.new(val[0], val[1], val[2], val[4], val[6]) }

  field_name : IDENT | "required" | "optional" | "repeated" | "import" | "package" | "option" | "message" | "extend" | "enum" | "service" | "rpc" | "returns" | "group" | "default" | "extensions" | "to" | "max" | "double" | "float" | "int32" | "int64" | "uint32" | "uint64" | "sint32" | "sint64" | "fixed32" | "fixed64" | "sfixed32" | "sfixed64" | "bool" | "string" | "bytes"

  field_option_list : field_option
                      { result = val }
                    | field_option_list ',' field_option
                      { result << val[2] }

  field_option : option_body
               | 'default' '=' constant
                 { result = [:default, val[2]] }

  extensions : 'extensions' extension comma_extension_list ';'
               { result = Protobuf::Node::ExtensionsNode.new(val[2].unshift(val[1])) }

  comma_extension_list :
                         { result = [] }
                       | ',' extension
                         { result << val[1] }

  extension : integer_literal
              { result = Protobuf::Node::ExtensionRangeNode.new(val[0]) }
            | integer_literal 'to' integer_literal
              { result = Protobuf::Node::ExtensionRangeNode.new(val[0], val[2]) }
            | integer_literal 'to' 'max'
              { result = Protobuf::Node::ExtensionRangeNode.new(val[0], :max) }

  label : 'required'
        | 'optional'
        | 'repeated'

  type : 'double' | 'float' | 'int32' | 'int64' | 'uint32' | 'uint64'
       | 'sint32' | 'sint64' | 'fixed32' | 'fixed64' | 'sfixed32' | 'sfixed64'
       | 'bool' | 'string' | 'bytes' | user_type

  user_type : IDENT dot_ident_list
              { result = val[1].unshift(val[0]) }
            | '.' IDENT dot_ident_list
              { result = val[1].unshift(val[0]) }

  constant : IDENT
           | integer_literal
           | FLOAT_LITERAL
           | STRING_LITERAL
           | BOOLEAN_LITERAL

  integer_literal : DEC_INTEGER
                  | HEX_INTEGER
                  | OCT_INTEGER
end

---- inner

  require 'strscan'

  def parse(f)
    @scanner = StringScanner.new(f.read)
    yyparse(self, :scan)
  end

  def scan_debug
    scan do |token, value|
      p [token, value]
      yield [token, value]
    end
  end

  def scan
    until @scanner.eos?
      case
      when match(/\s+/, /\/\/.*/)
        # skip
      when match(/\/\*/)
        # C-like comment
        raise 'EOF inside block comment' until @scanner.scan_until(/\*\//)
      when match(/(?:required|optional|repeated|import|package|option|message|extend|enum|service|rpc|returns|group|default|extensions|to|max|double|float|int32|int64|uint32|uint64|sint32|sint64|fixed32|fixed64|sfixed32|sfixed64|bool|string|bytes)\b/)
        yield [@token, @token.to_sym]
      when match(/[+-]?\d*\.\d+([Ee][\+-]?\d+)?/)
        yield [:FLOAT_LITERAL, @token.to_f]
      when match(/[+-]?[1-9]\d*(?!\.)/, /0(?![.xX0-9])/)
        yield [:DEC_INTEGER, @token.to_i]
      when match(/0[xX]([A-Fa-f0-9])+/)
        yield [:HEX_INTEGER, @token.to_i(0)]
      when match(/0[0-7]+/)
        yield [:OCT_INTEGER, @token.to_i(0)]
      when match(/(true|false)\b/)
        yield [:BOOLEAN_LITERAL, @token == 'true']
      when match(/"(?:[^"\\]+|\\.)*"/, /'(?:[^'\\]+|\\.)*'/)
        yield [:STRING_LITERAL, eval(@token)]
      when match(/[a-zA-Z_]\w*/)
        yield [:IDENT, @token.to_sym]
      when match(/[A-Z]\w*/)
        yield [:CAMEL_IDENT, @token.to_sym]
      when match(/./)
        yield [@token, @token]
      else
        raise "parse error around #{@scanner.string[@scanner.pos, 32].inspect}"
      end
    end
    yield [false, nil]
  end

  def match(*regular_expressions)
    regular_expressions.each do |re|
      if @scanner.scan(re)
        @token = @scanner[0]
        return true
      end
    end
    false
  end
