require 'rails_helper'

describe Wallaby::ApplicationHelper do
  describe '#url_for' do
    context 'when options is hash or permitted parameters' do
      it 'generates URL' do
        expect(helper.url_for(action: 'home')).to eq '/admin/'
        Wallaby::ERRORS.each do |error|
          expect(helper.url_for(action: error)).to eq "/admin/#{error}"
        end
        expect(helper.url_for(resources: 'products', action: 'index')).to eq '/admin/products'
        expect(helper.url_for(resources: 'products', action: 'new')).to eq '/admin/products/new'
        expect(helper.url_for(resources: 'products', action: 'show', id: 1)).to eq '/admin/products/1'
        expect(helper.url_for(resources: 'products', action: 'edit', id: 1)).to eq '/admin/products/1/edit'
      end

      it 'generates URL for permitted parameters' do
        expect(helper.url_for(parameters!(action: 'home'))).to eq '/admin/'
        Wallaby::ERRORS.each do |error|
          expect(helper.url_for(parameters!(action: error))).to eq "/admin/#{error}"
        end
        expect(helper.url_for(parameters!(resources: 'products', action: 'index'))).to eq '/admin/products'
        expect(helper.url_for(parameters!(resources: 'products', action: 'new'))).to eq '/admin/products/new'
        expect(helper.url_for(parameters!(resources: 'products', action: 'show', id: 1))).to eq '/admin/products/1'
        expect(helper.url_for(parameters!(resources: 'products', action: 'edit', id: 1))).to eq '/admin/products/1/edit'
      end

      it 'generates URL for before engine', script_name: '/before_engine' do
        expect(helper.url_for(action: 'home')).to eq '/before_engine/'
        Wallaby::ERRORS.each do |error|
          expect(helper.url_for(action: error)).to eq "/before_engine/#{error}"
        end
        expect(helper.url_for(resources: 'products', action: 'index')).to eq '/before_engine/products'
        expect(helper.url_for(resources: 'products', action: 'new')).to eq '/before_engine/products/new'
        expect(helper.url_for(resources: 'products', action: 'show', id: 1)).to eq '/before_engine/products/1'
        expect(helper.url_for(resources: 'products', action: 'edit', id: 1)).to eq '/before_engine/products/1/edit'
      end

      it 'generates URL for after engine', script_name: '/after_engine' do
        expect(helper.url_for(action: 'home')).to eq '/after_engine/'
        Wallaby::ERRORS.each do |error|
          expect(helper.url_for(action: error)).to eq "/after_engine/#{error}"
        end
        expect(helper.url_for(resources: 'products', action: 'index')).to eq '/after_engine/products'
        expect(helper.url_for(resources: 'products', action: 'new')).to eq '/after_engine/products/new'
        expect(helper.url_for(resources: 'products', action: 'show', id: 1)).to eq '/after_engine/products/1'
        expect(helper.url_for(resources: 'products', action: 'edit', id: 1)).to eq '/after_engine/products/1/edit'
      end
    end

    context 'when options is neither hash or permitted parameters' do
      it 'generates URL for strings' do
        expect(helper.url_for('')).to eq ''
        expect(helper.url_for('/products')).to eq '/products'
      end

      it 'generates URL for array' do
        expect(helper.url_for(%i(profile postcodes))).to eq '/profile/postcodes'
        expect(helper.url_for(%i(before products))).to eq '/before/products'
        expect { helper.url_for(%i(admin products)) }.to raise_error NoMethodError
      end
    end
  end

  describe '#form_for' do
    it 'uses the Wallaby::FormBuilder' do
      product = Product.new
      product.errors.add :name, 'invalid name'
      expect(helper.form_for(product) do |f|
        f.error_messages :name
      end).to include 'invalid name'
    end
  end
end
