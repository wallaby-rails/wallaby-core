require 'rails_helper'

describe Wallaby::Utils do
  describe '.inspect' do
    it 'returns filter name' do
      expect(described_class.inspect(nil)).to eq 'nil'
      expect(described_class.inspect(Person.new(id: 1))).to eq 'Person#1'
    end
  end
end
