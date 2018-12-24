require 'base64'
require 'benchmark/ips'
require 'pry'
require "./spec/support/protos/resource.pb"
#require "jruby/profiler/flame_graph_profile_printer"

VALUES = {
  0 => "AA==",
  5 => "BQ==",
  51 => "Mw==",
  9_192 => "6Ec=",
  80_389 => "hfQE",
  913_389 => "7d83",
  516_192_829_912_693 => "9eyMkpivdQ==",
  9_999_999_999_999_999_999 => "//+fz8jgyOOKAQ==",
}.freeze

#DECODEME = ::Derp.encode_cache_hash(2576)
#DECODEME2 = ::Derp.encode_cache_hash(25763111)

10_000.times do
    t = ::Test::Resource.new(:name => "derp", :date_created => 123456789)
    t.status = 3
    ss = StringIO.new
    ::Protobuf::Encoder.encode(t.to_proto, ss)
    ss.rewind
    t2 = ::Test::Resource.decode_from(ss)
end

if ENV["FLAME"]
  result = JRuby::Profiler.profile do
    1_000_000.times do
      t = ::Test::Resource.new(:name => "derp", :date_created => 123456789)
      t.status = 3
      ss = StringIO.new
      ::Protobuf::Encoder.encode(t.to_proto, ss)
      ss.rewind
      t2 = ::Test::Resource.decode_from(ss)
      #fail "derp" unless t == t2
  
      #t = ::Test::Resource.new(:name => "derp", :date_created => 123456789)
      #t.field?(:name)
      #t.field?(:date_created)
      #t.field?(:derp_derp)
      #t.respond_to_has_and_present?(:name)
      #t.respond_to_has_and_present?(:date_created)
      #t.respond_to_has_and_present?(:derp_derp)
    end
  end
  
  printer = JRuby::Profiler::FlameGraphProfilePrinter.new(result)
  printer.printProfile(STDOUT)
else
  TO_HASH = ::Test::Resource.new(:name => "derp", :date_created => 123456789)
  Benchmark.ips do |x|
    x.config(:time => 10, :warmup => 10)
    x.report("to_hash => true java") do
      TO_HASH.to_hash
    end

    x.report("to_proto => true java") do
      t = ::Test::Resource.new(:name => "derp", :date_created => 123456789)
      t.status = 3
      ss = StringIO.new
      ::Protobuf::Encoder.encode(t.to_proto, ss)
      ss.rewind
      t2 = ::Test::Resource.decode_from(ss)
    end
  end
end
