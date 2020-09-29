require 'rails_helper'

describe Wallaby::EngineUrlFor, type: :helper do
  describe '.execute' do
    context 'when action is index' do
      it 'returns resources_path' do
        %w(index).each do |action|
          expect(described_class.execute(context: helper, params: { action: action }, options: { engine_name: 'wallaby_engine', model_class: Product })).to eq '/admin/products'
          expect(described_class.execute(context: helper, params: parameters!(action: action), options: { engine_name: 'wallaby_engine', model_class: Product })).to eq '/admin/products'
        end
      end
    end

    context 'when action is new' do
      it 'returns new_resource_path' do
        expect(described_class.execute(context: helper, params: { action: 'new' }, options: { engine_name: 'wallaby_engine', model_class: Product })).to eq '/admin/products/new'
        expect(described_class.execute(context: helper, params: parameters!(action: 'new'), options: { engine_name: 'wallaby_engine', model_class: Product })).to eq '/admin/products/new'
      end
    end

    context 'when action is edit' do
      it 'returns edit_resource_path' do
        expect(described_class.execute(context: helper, params: { action: 'edit', id: 1 }, options: { engine_name: 'wallaby_engine', model_class: Product })).to eq '/admin/products/1/edit'
        expect(described_class.execute(context: helper, params: parameters!(action: 'edit', id: 1), options: { engine_name: 'wallaby_engine', model_class: Product })).to eq '/admin/products/1/edit'
      end
    end

    context 'when action is show' do
      it 'returns resource_path' do
        %w(show).each do |action|
          expect(described_class.execute(context: helper, params: { action: action, id: 1 }, options: { engine_name: 'wallaby_engine', model_class: Product })).to eq '/admin/products/1'
          expect(described_class.execute(context: helper, params: parameters!(action: action, id: 1), options: { engine_name: 'wallaby_engine', model_class: Product })).to eq '/admin/products/1'
        end
      end
    end
  end
end
