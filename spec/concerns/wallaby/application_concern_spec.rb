require 'rails_helper'

describe Wallaby::ResourcesController, type: :controller do
  describe 'configuration shortcuts' do
    describe '#configuration' do
      it { expect(controller.configuration).to be_a Wallaby::Configuration }
    end

    # describe '#models' do
    #   it { expect(controller.models).to be_a Wallaby::Configuration::Models }
    # end

    # describe '#security' do
    #   it { expect(controller.security).to be_a Wallaby::Configuration::Security }
    # end

    # describe '#mapping' do
    #   it { expect(controller.mapping).to be_a Wallaby::Configuration::Mapping }
    # end

    # describe '#default_metadata' do
    #   it { expect(controller.default_metadata).to be_a Wallaby::Configuration::Metadata }
    # end

    # describe '#pagination' do
    #   it { expect(controller.pagination).to be_a Wallaby::Configuration::Pagination }
    # end

    # describe '#features' do
    #   it { expect(controller.features).to be_a Wallaby::Configuration::Features }
    # end
  end

  describe '#healthy' do
    it 'returns healthy' do
      get :healthy
      expect(response.body).to eq 'healthy'

      get :healthy, format: :json
      expect(response.body).to eq 'healthy'
    end
  end

  describe 'error handling' do
    describe 'Wallaby::ResourceNotFound' do
      controller do
        def index
          raise Wallaby::ResourceNotFound, 1
        end
      end

      it 'rescues the exception and renders 404' do
        expect { get :index }.not_to raise_error
        expect(response.status).to eq 404
        expect(response).to render_template :error
      end
    end

    describe 'Wallaby::ModelNotFound' do
      controller do
        def index
          raise Wallaby::ModelNotFound, 'Product'
        end
      end

      it 'rescues the exception and renders 404' do
        expect { get :index }.not_to raise_error
        expect(response.status).to eq 404
        expect(response).to render_template :error
      end
    end

    describe 'ActionController::ParameterMissing' do
      controller do
        def index
          params.require(:product)
        end
      end

      it 'rescues the exception and renders 400' do
        expect { get :index }.not_to raise_error
        expect(response.status).to eq 400
        expect(response).to render_template :error
      end
    end

    describe 'ActiveRecord::StatementInvalid' do
      controller do
        def index
          Product.where(unknown: false).to_a
        end
      end

      it 'rescues the exception and renders 422' do
        expect { get :index }.not_to raise_error
        expect(response.status).to eq 422
        expect(response).to render_template :error
      end
    end
  end
end
