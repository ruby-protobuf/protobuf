require 'spec_helper'

describe ::Protobuf::Field::StringField do
  describe '#encode' do
    context 'when a repeated string field contains frozen strings' do
      it 'does not raise an encoding error' do
        expect {
          frozen_strings = [ "foo".freeze, "bar".freeze, "baz".freeze ]
          ::Test::ResourceFindRequest.encode(:name => 'resource', :widgets => frozen_strings)
        }.not_to raise_error
      end
    end

    context 'when a repeated bytes field contains frozen strings' do
      it 'does not raise an encoding error' do
        expect {
          frozen_strings = [ "foo".freeze, "bar".freeze, "baz".freeze ]
          ::Test::ResourceFindRequest.encode(:name => 'resource', :widget_bytes => frozen_strings)
        }.not_to raise_error
      end
    end
  end
end
