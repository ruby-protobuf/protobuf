require 'spec_helper'

RSpec.describe Protobuf::Field::Int32Field do

  it_behaves_like :packable_field, described_class

end
