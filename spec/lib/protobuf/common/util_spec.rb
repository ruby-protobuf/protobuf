require 'spec_helper'

describe Protobuf::Util do
  
  describe '.camelize' do
    it 'converts underscored word to camel case' do
      Protobuf::Util.camelize('widget_request').should eq 'WidgetRequest'
    end
    
    it 'concatenates an array of words as a namespaced camelized string' do
      Protobuf::Util.camelize(['big_widget', 'update_request']).should eq 'BigWidget::UpdateRequest'
    end
  end
  
  describe '.underscore' do
    it 'underscores a camelized word' do
      Protobuf::Util.underscore('WidgetRequest').should eq 'widget_request'
    end
  end
  
  describe '.module_to_path' do
    it 'underscores words and converts ruby namespace separators into path separators' do
      Protobuf::Util.module_to_path('BigWidget::WidgetRequest').should eq 'big_widget/widget_request'
    end
  end
  
  describe '.package_to_path' do
    it 'underscores words and converts protobuf (java-style) namespace separators into path separators' do
      Protobuf::Util.package_to_path('BigWidget.WidgetRequest').should eq 'big_widget/widget_request'
    end
  end
  
  describe '.packagize' do
    it 'converts ruby namespace to protobuf (java-style) namespace' do
      Protobuf::Util.packagize('Big::BlueWidget::WidgetRequest').should eq 'big.blue_widget.WidgetRequest'
    end
  end
  
  describe '.moduleize' do
    it 'converts protobuf (java-style) namespaces to ruby namespace' do
      Protobuf::Util.moduleize('big.blue_widget.WidgetRequest').should eq 'Big::BlueWidget::WidgetRequest'
    end
  end
  
  describe '.constantize' do
    it 'gets the class/module constant from a protobuf namespaced string' do
      Protobuf::Util.constantize('protobuf.Util').should eq Protobuf::Util
    end
  end
end