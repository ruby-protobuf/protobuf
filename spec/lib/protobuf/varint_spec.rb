require 'base64'
require 'spec_helper'

RSpec.describe Protobuf::Varint do
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

  [defined?(::Varint) ? ::Varint : nil, Protobuf::VarintPure].compact.each do |klass|
    context "with #{klass}" do
      before { described_class.extend(klass) }
      after { load ::File.expand_path('../../../../lib/protobuf/varint.rb', __FILE__) }

      VALUES.each do |number, encoded|
        it "decodes #{number}" do
          io = StringIO.new(Base64.decode64(encoded))
          expect(described_class.decode(io)).to eq(number)
        end
      end

      # Each value is at the edge of a byte count, so the last byte changes.
      {
        127 => "fw==",
        128 => "gAE=",
        16_383 => "/38=",
        16_384 => "gIAB",
        4_294_967_295 => "/////w8=",
        9_223_372_036_854_775_807 => "//////////9/",
        18_446_744_073_709_551_615 => "////////////AQ==",
      }.each do |number, encoded|
        it "decodes #{number} and stops at the end of the varint" do
          io = StringIO.new(Base64.decode64(encoded) + "\x01".b)
          expect(described_class.decode(io)).to eq(number)
          expect(io.read).to eq("\x01".b)
        end
      end

      # The C varint gem raises TypeError here, so only VarintPure has this test.
      if klass == Protobuf::VarintPure
        it "raises EOFError on a varint without its last byte" do
          expect { described_class.decode(StringIO.new("\x80\x80".b)) }.to raise_error(EOFError)
        end
      end
    end
  end
end
