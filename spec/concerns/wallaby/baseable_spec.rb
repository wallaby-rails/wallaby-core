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
  describe '.guess_associated_class_of' do
    before { stub_const('Core::Special::SupermenController', Class.new) }

    it 'returns the associated class' do
      stub_const('Special::SupermanDecorator', Class.new)
      expect(described_class.guess_associated_class_of(Core::Special::SupermenController.name, suffix: 'Decorator')).to eq Special::SupermanDecorator
    end

    context 'when not found' do
      it 'raises ClassNotFound' do
        expect { described_class.guess_associated_class_of(Core::Special::SupermenController.name) }.to raise_error Wallaby::ClassNotFound
      end
    end

    context 'when there are many classes meet the rules' do
      it 'returns the one matches the most' do
        stub_const('Superman', Class.new)
        stub_const('Core::Special', Class.new)
        stub_const('Core::Superman', Class.new)
        stub_const('Special::Superman', Class.new)
        stub_const('Core::Special::Supermen', Class.new)
        stub_const('Core::Special::SupermenController', Class.new)

        expect(described_class.guess_associated_class_of(Core::Special::SupermenController.name)).to eq Special::Superman
      end
    end
  end

  describe 'included' do
    subject do
      stub_const('Core::SomethingDecorator', Class.new(base_class))
    end

    let(:base_class) do
      stub_const('BaseClass', Class.new do
        extend Wallaby::Baseable::ClassMethods
        base_class!
      end)
    end

    describe '.base_class?' do
      it 'returns false' do
        expect(base_class).to be_base_class
        expect(subject).not_to be_base_class
      end
    end

    describe '.base_class' do
      it 'returns it parent' do
        expect(base_class.base_class).to eq base_class
        expect(subject.base_class).to eq base_class
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
        it 'raises NameError' do
          expect { subject.model_class }.to raise_error Wallaby::ClassNotFound
        end
      end
    end
  end
end
