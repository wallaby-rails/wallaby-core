require 'rails_helper'

describe 'custom routes and its custom controllers/actions', type: :request do
  let!(:category) { Category.create(name: FFaker::Name.name) }

  it 'renders resourcesful actions (e.g. index) ok' do
    http :get, '/admin/categories'
    expect(response).to be_successful
    expect(response).to render_template :index
    expect(page_html.at_css('.index')['href']).to end_with '/admin/categories'
    expect(page_html.at_css('.new')['href']).to end_with '/admin/categories/new'
    expect(page_html.at_css('.show')['href']).to end_with "/admin/categories/#{category.id}"
    expect(page_html.at_css('.edit')['href']).to end_with "/admin/categories/#{category.id}/edit"
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
end
