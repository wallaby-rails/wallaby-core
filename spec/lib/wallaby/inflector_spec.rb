require 'rails_helper'

describe Wallaby::Inflector do
  describe '.to_controller_name' do
    it 'returns the controller class name' do
      expect(described_class.to_controller_name('/admin', 'categories')).to eq 'Admin::CategoriesController'
      expect(described_class.to_controller_name('/admin', 'category')).to eq 'Admin::CategoryController'
    end

    context 'with namespace' do
      it 'returns the controller class name' do
        expect(described_class.to_controller_name('/admin', 'order::items')).to eq 'Admin::Order::ItemsController'
        expect(described_class.to_controller_name('/admin', 'order::item')).to eq 'Admin::Order::ItemController'
      end
    end

    context 'with empty script name' do
      it 'returns the controller class name' do
        expect(described_class.to_controller_name('', 'categories')).to eq 'CategoriesController'
        expect(described_class.to_controller_name('', 'category')).to eq 'CategoryController'
      end

      context 'with namespace' do
        it 'returns the controller class name' do
          expect(described_class.to_controller_name('', 'order::items')).to eq 'Order::ItemsController'
          expect(described_class.to_controller_name('', 'order::item')).to eq 'Order::ItemController'
        end
      end
    end
  end
end
