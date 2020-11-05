require 'rails_helper'

describe Wallaby::Inflector do
  describe '.to_class_name' do
    it 'returns class name' do
      expect(described_class.to_class_name('')).to eq ''

      expect(described_class.to_class_name('admin/categories')).to eq 'Admin::Category'
      expect(described_class.to_class_name('admin::category')).to eq 'Admin::Category'
      expect(described_class.to_class_name('/admin/categories')).to eq '::Admin::Category'
      expect(described_class.to_class_name('/admin::category')).to eq '::Admin::Category'
    end
  end

  describe '.to_script' do
    it 'returns string' do
      expect(described_class.to_script('', 'category')).to eq 'category'
      expect(described_class.to_script('', 'categories')).to eq 'categories'
      expect(described_class.to_script('', 'order::item')).to eq 'order::item'
      expect(described_class.to_script('', 'order::items')).to eq 'order::items'
      expect(described_class.to_script('', 'order::items', '_controller')).to eq 'order::items_controller'

      expect(described_class.to_script('/admin', 'categories')).to eq 'admin/categories'
      expect(described_class.to_script('/admin', 'order::items')).to eq 'admin/order::items'
      expect(described_class.to_script('/admin', 'order::items', '_controller')).to eq 'admin/order::items_controller'
    end
  end

  describe '.to_controller_name' do
    it 'returns the controller class name' do
      expect(described_class.to_controller_name('/admin', 'categories')).to eq 'Admin::CategoriesController'
      expect(described_class.to_controller_name('/admin', 'category')).to eq 'Admin::CategoryController'
      expect(described_class.to_controller_name('/admin', 'order::items')).to eq 'Admin::Order::ItemsController'
      expect(described_class.to_controller_name('/admin', 'order::item')).to eq 'Admin::Order::ItemController'
      expect(described_class.to_controller_name('/admin', 'Order::Item')).to eq 'Admin::Order::ItemController'
    end
  end

  describe '.to_decorator_name' do
    it 'returns the decorator class name' do
      expect(described_class.to_decorator_name('/admin', 'categories')).to eq 'Admin::CategoryDecorator'
      expect(described_class.to_decorator_name('/admin', 'category')).to eq 'Admin::CategoryDecorator'
      expect(described_class.to_decorator_name('/admin', 'order::items')).to eq 'Admin::Order::ItemDecorator'
      expect(described_class.to_decorator_name('/admin', 'order::item')).to eq 'Admin::Order::ItemDecorator'
      expect(described_class.to_decorator_name('/admin', 'Order::Item')).to eq 'Admin::Order::ItemDecorator'
    end
  end

  describe '.to_authorizer_name' do
    it 'returns the authorizer class name' do
      expect(described_class.to_authorizer_name('/admin', 'categories')).to eq 'Admin::CategoryAuthorizer'
      expect(described_class.to_authorizer_name('/admin', 'category')).to eq 'Admin::CategoryAuthorizer'
      expect(described_class.to_authorizer_name('/admin', 'order::items')).to eq 'Admin::Order::ItemAuthorizer'
      expect(described_class.to_authorizer_name('/admin', 'order::item')).to eq 'Admin::Order::ItemAuthorizer'
    end
  end
end
