module App
  class PicturesController < ApplicationController
    include Wallaby::ResourcesConcern
    self.responder = Wallaby::JsonApiResponder
  end
end
