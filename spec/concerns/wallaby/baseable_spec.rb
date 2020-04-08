require 'rails_helper'

[
  Wallaby::ResourceDecorator,
  Wallaby::ResourcesController,
  Wallaby::ModelAuthorizer,
  Wallaby::ModelServicer,
  Wallaby::ModelPaginator
].each do |klass|
  describe klass do
    describe '.base_class!' do
      it 'returns true' do
        expect(described_class).to be_base_class
        expect(described_class.base_class).to eq klass
      end
    end

    describe '.model_class' do
      it 'returns nil' do
        expect(described_class.model_class).to be_nil
      end
    end
  end
end

describe Wallaby::Baseable do
  subject do
    stub_const('BaseClass', Class.new do
      extend Wallaby::Baseable::ClassMethods
      base_class!
    end)
    stub_const('Core::SomethingDecorator', Class.new(BaseClass))
  end

  describe '.base_class!' do
    it 'returns false' do
      expect(subject).not_to be_base_class
    end
  end

  describe '.base_class' do
    it 'returns it parent' do
      expect(subject.base_class).to eq BaseClass
    end
  end

  describe '.model_class' do
    context 'when assoicated model class exists' do
      before do
        stub_const('Something', Class.new)
      end

      it 'returns it parent' do
        expect(subject.model_class).to eq Something
      end
    end

    context 'when multiple assoicated models class exists' do
      before do
        stub_const('Something', Class.new)
        stub_const('Core::Something', Class.new)
      end

      it 'returns it parent' do
        expect(subject.model_class).to eq Core::Something
      end
    end

    context 'when assoicated model class does not exist' do
      it 'raises ModelNotFound' do
        expect { subject.model_class }.to raise_error Wallaby::ModelNotFound
      end
    end
  end
end
