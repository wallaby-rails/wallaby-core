require 'rails_helper'

describe 'GlobalPaginator', type: :request do
  before do
    stub_const 'GlobalPaginator', (Class.new Wallaby::ModelPaginator do
      base_class!
      def total
        999
      end
    end)

    Wallaby.configuration.mapping.model_paginator = GlobalPaginator
  end

  it 'uses the configured resources paginator instead of ResourcesPaginator' do
    Picture.create! name: 'a picture'
    get '/admin/pictures'
    expect(response).to be_successful
    expect(response.body).to include '999'
  end
end
