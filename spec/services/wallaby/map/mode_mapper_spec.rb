require 'rails_helper'

describe Wallaby::Map::ModeMapper do
  describe '.execute' do
    context 'when given class_names is blank' do
      it 'returns empty hash' do
        expect(described_class.execute(nil)).to eq({})
        expect(described_class.execute([])).to eq({})
      end
    end

    context 'when mode classes are not empty' do
      before do
        Wallaby.configuration.custom_models = [Array, Hash]
      end

      it 'returns a mode map' do
        expect(described_class.execute(Wallaby::ClassArray.new([Wallaby::Custom]))).to be_a Wallaby::ClassHash
        expect(described_class.execute(Wallaby::ClassArray.new([Wallaby::Custom]))).to eq \
          'Array' => 'Wallaby::Custom',
          'Hash' => 'Wallaby::Custom'
        expect(described_class.execute(Wallaby::ClassArray.new(['Wallaby::Custom']))).to eq \
          'Array' => 'Wallaby::Custom',
          'Hash' => 'Wallaby::Custom'
      end

      context 'when Array is given' do
        it 'returns a mode map' do
          expect(described_class.execute(Wallaby::ClassArray.new([Wallaby::Custom]))).to be_a Wallaby::ClassHash
          expect(described_class.execute([Wallaby::Custom])).to eq \
            'Array' => 'Wallaby::Custom',
            'Hash' => 'Wallaby::Custom'
        end
      end
    end
  end
end
