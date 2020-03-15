require 'rails_helper'

describe Wallaby do
  it 'returns translation' do
    expect(described_class.t('wallaby.labels.count')).to eq 'Count: '
    expect(described_class.t('labels.count')).to eq 'Count: '
  end

  context 'when translation is not under wallaby namespace' do
    it 'returns translation' do
      expect(described_class.t('fa.v4.clock')).to eq 'clock-o'
    end
  end
end
