module Resources
  class PicturesController < Wallaby::ResourcesController
    self.responder = Wallaby::JsonApiResponder
  end
end
