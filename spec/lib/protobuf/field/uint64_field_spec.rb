require 'spec_helper'

RSpec.describe Protobuf::Field::Uint64Field do

  it_behaves_like :packable_field, described_class

end
