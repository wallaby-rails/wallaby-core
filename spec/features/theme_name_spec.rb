require 'rails_helper'

describe 'blog that uses theme', type: :request do
  before do
    10.times do
      Blog.create(
        author: FFaker::Name.name,
        subject: FFaker::Lorem.sentence,
        summary: FFaker::Lorem.sentence(20),
        body: FFaker::Lorem.sentence(100)
      )
    end
  end

  let(:blog) { Blog.first }

  describe 'post list page' do
    it 'renders the theme' do
      http :get, '/blogs'
      expect(response).to be_successful
      expect(response).to render_template 'layouts/simple_blog_theme'
      expect(response).to render_template 'simple_blog_theme/index'
      expect(response.body).to include blog.subject
    end
  end

  describe 'post show page' do
    it 'renders the theme' do
      http :get, "/blogs/#{blog.id}"
      expect(response).to be_successful
      expect(response).to render_template 'layouts/simple_blog_theme'
      expect(response).to render_template 'simple_blog_theme/show'
      expect(response.body).to include blog.body
      expect(response.body).to include blog.subject
    end
  end
end
