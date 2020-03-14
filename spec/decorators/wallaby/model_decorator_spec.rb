require 'rails_helper'

describe Wallaby::ModelDecorator do
  subject { described_class.new model_class }

  let(:model_class) { nil }

  describe '#resources_name' do
    let(:model_class) { instance_double 'model', to_s: 'Core::Post' }

    it 'returns resources name for model class' do
      expect(subject.resources_name).to eq 'core::posts'
    end
  end

  describe '#index/show/form_fields=' do
    %w(index_ show_ form_).each do |prefix|
      it 'ensures assigned hash becomes ::ActiveSupport::HashWithIndifferentAccess' do
        subject.send "#{prefix}fields=", name: { type: 'string' }
        expect(subject.instance_variable_get("@#{prefix}fields")).to be_a ::ActiveSupport::HashWithIndifferentAccess
        expect(subject.instance_variable_get("@#{prefix}fields")).to eq 'name' => { 'type' => 'string' }
      end
    end
  end
end
