require 'rails_helper'

describe Wallaby::ClassHash do
  it 'stores Class key/value as String' do
    subject[Class] = Module
    expect(subject).to eq 'Class' => 'Module'

    subject['Class'] = Object
    expect(subject).to eq 'Class' => 'Object'

    subject['Class'] = 'Array'
    expect(subject).to eq 'Class' => 'Array'
  end

  it 'returns String value as Class' do
    subject[Class] = Module
    expect(subject[Class]).to eq Module
    expect(subject['Class']).to eq Module
  end

  it 'merges and returns new ClassHash' do
    new_hash = subject.merge(Class => Module)
    expect(new_hash).to be_kind_of described_class
    expect(new_hash).to eq 'Class' => 'Module'
    expect(new_hash[Class]).to eq Module
  end
end
