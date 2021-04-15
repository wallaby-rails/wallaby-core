require 'rails_helper'

describe 'Error pages' do
  Wallaby::ERRORS.each do |status|
    code = Rack::Utils::SYMBOL_TO_STATUS_CODE[status]

    describe status do
      it 'responses' do
        get "/admin/#{status}"
        expect(response.status).to eq code
        expect(response).to render_template :error
        expect(response.body).to include status.to_s
      end
    end

    describe code do
      it 'responses' do
        get "/admin/#{code}"
        expect(response.status).to eq code
        expect(response).to render_template :error
        expect(response.body).to include status.to_s
      end
    end
  end
end
