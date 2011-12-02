# Just a way to keep warnings from being flagged in rename of constants during tests
module Kernel
  def silence_warnings
    orig_verbosity = $VERBOSE
    $VERBOSE = nil
    yield
    $VERBOSE = orig_verbosity
  end
end

module SilentConstants
  def parse(constant)
    source, _, constant_name = constant.to_s.rpartition('::')
    [Object.const_get(source.to_sym), constant_name.to_sym]
  end

  # Examples
  # with_constants "Something" => "nothing" do 
  # end
  #
  # with_constants "Something::Foo" => "something else" do 
  # end
  #
  def with_constants(constants, &block)
    saved_constants = {}
    constants.each do |constant, val|
      source_object, const_name = parse(constant)
      saved_constants[constant] = source_object.const_get(const_name)
      Kernel::silence_warnings { source_object.const_set(const_name, val) }
    end

    begin
      block.call
    ensure
      constants.each do |constant, val|
        source_object, const_name = parse(constant)
        Kernel::silence_warnings { source_object.const_set(const_name, saved_constants[constant]) }
      end
    end
  end
end
