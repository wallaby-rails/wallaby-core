module Json
  class PicturesController < ActionController::API
    include Wallaby::ResourcesConcern
    self.responder = Wallaby::JsonApiResponder
  end
end
