module ControllerSupport
  extend ActiveSupport::Concern

  included do
    routes { ::Wallaby::Engine.routes }
  end
end

RSpec.configure do |config|
  config.include ControllerSupport, type: :controller

  config.before :each, type: :controller do |example|
    controller.request.env['SCRIPT_NAME'] = example.metadata[:script_name] || '/admin'
  end
end
