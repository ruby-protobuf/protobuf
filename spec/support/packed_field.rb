if defined?(RSpec)
  shared_examples_for :packable_field do |klass|

    before(:all) do
      unless defined?(PackableFieldTest)
        class PackableFieldTest < ::Protobuf::Message; end
      end

      field_klass = klass
      field_name = "#{klass.name.split('::').last.underscore}_packed_field".to_sym
      tag_num = PackableFieldTest.fields.size + 1
      PackableFieldTest.repeated(field_klass, field_name, tag_num, :packed => true)
    end

    let(:field_name) { "#{klass.name.split('::').last.underscore}_packed_field" }
    let(:message_instance) { PackableFieldTest.new(field_name => [100, 200, 300]) }

    subject { message_instance.fields.last }

    it { should be_packed }

  end
end
