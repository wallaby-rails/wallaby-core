require 'rails_helper'

describe 'custom routes and its custom controllers/actions', type: :request do
  context 'when for ordinary controller' do
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
  end

  context 'when for custom controller' do
    it 'renders resourcesful actions (e.g. index) ok' do
      http :get, '/admin/not_like_categories'
      expect(response).to be_successful
      expect(response).to render_template :index
    end

    it 'reneders custom member action' do
      http :get, '/admin/not_like_categories/1/member_only'
      expect(response).to be_successful
      expect(response.body).to eq 'This is a member only action for Admin::NotLikeCategoriesController'
    end

    it 'reneders custom collection action' do
      http :get, '/admin/not_like_categories/collection_only'
      expect(response).to be_successful
      expect(response.body).to eq 'This is a collection only action for Admin::NotLikeCategoriesController'
    end
  end
end
