require 'rails_helper'

describe 'include as module', type: :request do
  let!(:order) { Order.create!(customer: FFaker::Name.name) }
  let!(:product) { Product.create!(name: 'new Product') }
  let(:item) { Order::Item.first }

  before do
    10.times do |i|
      Order::Item.create!(order: order, product: product, quantity: i, price: 99)
    end
  end

  describe 'order item list page' do
    it 'renders the page' do
      http :get, "/orders/#{order.id}/items"
      expect(response).to be_successful
      expect(response).to render_template 'layouts/wallaby/resources'
      expect(response).to render_template 'wallaby/resources/index'
      expect(response.body).to include item.quantity.to_s
    end
  end

  describe 'order item show page' do
    it 'renders the page' do
      http :get, "/orders/#{order.id}/items/#{item.id}"
      expect(response).to be_successful
      expect(response).to render_template 'layouts/wallaby/resources'
      expect(response).to render_template 'wallaby/resources/show'
      expect(response.body).to include item.id.to_s
      expect(response.body).to include item.quantity.to_s
    end
  end

  describe 'GET prefixes' do
    it 'returns the prefixes' do
      http :get, "/orders/#{order.id}/items/prefixes"
      expect(response).to be_successful
      expect(parse_body_for(response)).to eq ['items/prefixes', 'items/form', 'items', 'base/prefixes', 'base/form', 'base', 'wallaby/resources/prefixes', 'wallaby/resources/form', 'wallaby/resources', 'application/prefixes', 'application/form', 'application']
    end
  end
end
