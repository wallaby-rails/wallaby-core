if Rails::VERSION::MAJOR >= 5
  module Json
    class PicturesController < ActionController::API
      include Wallaby::ResourcesConcern
      self.responder = Wallaby::JsonApiResponder
    end
  end
end
