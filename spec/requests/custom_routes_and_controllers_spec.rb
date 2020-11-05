require 'rails_helper'

describe 'overrides the resourceful routes', type: :request do
  let!(:category) { Category.create(name: FFaker::Name.name) }

  it 'renders resourcesful actions (e.g. index) ok' do
    http :get, '/admin/categories'
    expect(response).to be_successful
    expect(response).to render_template :index
  end

  it 'reneders custom member action' do
    http :get, '/admin/categories/1/member_only'
    expect(response).to be_successful
    expect(response.body).to eq 'This is a member only action for Admin::CategoriesController'
  end

  it 'reneders custom collection action' do
    http :get, '/admin/categories/collection_only'
    expect(response).to be_successful
    expect(response.body).to eq 'This is a collection only action for Admin::CategoriesController'
  end

  it 'reneders links' do
    http :get, '/admin/categories/links'
    expect(response).to be_successful
    expect(page_json['index']).to include('/admin/categories')
    expect(page_json['new']).to include('/admin/categories/new')
    expect(page_json['show']).to include('/admin/categories/1')
    expect(page_json['edit']).to include('/admin/categories/1/edit')
  end
end

describe 'add custom resourceful routes', type: :request do
  let!(:category) { Category.create(name: FFaker::Name.name) }

  it 'renders resourcesful actions (e.g. index) ok' do
    http :get, '/admin/custom_categories'
    expect(response).to be_successful
    expect(response).to render_template :index
  end

  it 'reneders custom member action' do
    http :get, '/admin/custom_categories/1/member_only'
    expect(response).to be_successful
    expect(response.body).to eq 'This is a member only action for Admin::CustomCategoriesController'
  end

  it 'reneders custom collection action' do
    http :get, '/admin/custom_categories/collection_only'
    expect(response).to be_successful
    expect(response.body).to eq 'This is a collection only action for Admin::CustomCategoriesController'
  end

  it 'reneders links' do
    http :get, '/admin/custom_categories/links'
    expect(response).to be_successful
    expect(page_json['index']).to include('/admin/custom_categories')
    expect(page_json['new']).to include('/admin/custom_categories/new')
    expect(page_json['show']).to include('/admin/custom_categories/1')
    expect(page_json['edit']).to include('/admin/custom_categories/1/edit')
  end
end
