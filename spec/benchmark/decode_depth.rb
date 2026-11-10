# Decode speed for flat, wide, and deep messages. To compare two versions of
# the gem, run the script once with the lib directory of each:
#
#   git worktree add /tmp/protobuf_base <base commit>
#   bundle exec ruby -I/tmp/protobuf_base/lib spec/benchmark/decode_depth.rb
#   bundle exec ruby -Ilib spec/benchmark/decode_depth.rb
#
# T sets the seconds for each report (default 3). On JRuby, use T=10 or more
# so that the JIT warms up. DEEP=0 skips the deep chains, which a recursive
# decode cannot do.
require 'benchmark/ips'
require 'protobuf'

module DecodeDepthBench
  class Color < ::Protobuf::Enum
    define :RED, 0
    define :GREEN, 1
  end

  class Inner < ::Protobuf::Message
    optional :int32, :id, 1
    optional :string, :name, 2
    optional :bool, :active, 3
  end

  class Big < ::Protobuf::Message
    optional :int64, :id, 1
    optional :string, :name, 2
    optional :string, :email, 3
    optional :bool, :active, 4
    optional :uint32, :count, 5
    optional :sint64, :delta, 6
    optional :double, :score, 7
    optional :bytes, :blob, 8
    optional ::DecodeDepthBench::Color, :color, 9
    optional ::DecodeDepthBench::Inner, :inner, 10
    repeated :int32, :nums, 11
    repeated ::DecodeDepthBench::Inner, :children, 12
    repeated :string, :tags, 13
    map :string, :int64, :attrs, 14
  end

  class Tree < ::Protobuf::Message
    optional :int32, :v, 1
    optional :string, :name, 2
    repeated ::DecodeDepthBench::Tree, :kids, 3
  end

  class Chain < ::Protobuf::Message
    optional :int32, :v, 1
    optional ::DecodeDepthBench::Chain, :next, 2
  end

  def self.big
    Big.new(
      :id => 1_234_567_890_123, :name => "Test Name" * 3, :email => "someone@example.com",
      :active => true, :count => 42, :delta => -500, :score => 3.14159, :blob => "\x00\x01\x02".b * 10,
      :color => Color::GREEN, :inner => { :id => 7, :name => "inner", :active => true },
      :nums => (1..20).to_a, :children => (1..5).map { |i| { :id => i, :name => "child#{i}", :active => i.odd? } },
      :tags => %w[a bb ccc dddd], :attrs => { "x" => 1, "y" => 2 }
    )
  end

  def self.tree(depth, fanout)
    node = Tree.new(:v => depth, :name => "n#{depth}")
    node.kids = Array.new(fanout) { tree(depth - 1, fanout) } if depth > 0
    node
  end

  def self.chain_bytes(depth)
    bytes = "\x08\x01".b
    depth.times { bytes = "\x12".b + ::Protobuf::Varint.encode(bytes.bytesize) + bytes }
    bytes
  end

  def self.allocations
    GC.start
    before = GC.stat(:total_allocated_objects)
    yield
    GC.stat(:total_allocated_objects) - before
  end
end

bench = DecodeDepthBench
cases = {
  "Big (#{bench.big.encode.bytesize} B)" => [bench::Big, bench.big.encode],
  "Tree 4x4 (341 messages)" => [bench::Tree, bench.tree(4, 4).encode],
  "Chain 100" => [bench::Chain, bench.chain_bytes(100)],
}

cases.each_value do |klass, bytes|
  fail "round trip failed for #{klass}" unless klass.decode(bytes).encode == bytes
end

puts "#{RUBY_ENGINE} #{RUBY_VERSION} lib=#{$LOAD_PATH.find { |path| File.exist?(File.join(path, 'protobuf.rb')) }} " \
     "iterative=#{::Protobuf::Decoder.respond_to?(:decode_message) ? 1 : 0} varint_c=#{defined?(::Varint) ? 1 : 0} " \
     "java_helpers=#{defined?(::ProtobufJavaHelpers) ? 1 : 0} yjit=#{defined?(RubyVM::YJIT) && RubyVM::YJIT.enabled? ? 1 : 0}"

if RUBY_ENGINE == 'ruby'
  puts "\nAllocations for each decode:"
  cases.each do |label, (klass, bytes)|
    puts format("  %<label>-26s %<count>6d", :label => label, :count => bench.allocations { klass.decode(bytes) })
  end
end

seconds = Integer(ENV.fetch('T', 3))
puts
Benchmark.ips do |x|
  x.config(:time => seconds, :warmup => [seconds / 2, 1].max)
  cases.each do |label, (klass, bytes)|
    x.report(label) { klass.decode(bytes) }
  end
end

unless ENV['DEEP'] == '0'
  puts "\nDeep chains (time must grow linearly with depth):"
  [1_000, 10_000, 100_000].each do |depth|
    bytes = bench.chain_bytes(depth)
    bench::Chain.decode(bytes)
    started = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    bench::Chain.decode(bytes)
    elapsed = Process.clock_gettime(Process::CLOCK_MONOTONIC) - started
    puts format("  %<depth>7d levels: %<ms>8.1f ms (%<us>.2f us per level)",
                :depth => depth, :ms => elapsed * 1000, :us => elapsed * 1_000_000 / depth)
  end
end
