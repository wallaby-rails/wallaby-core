module Admin
  class CustomCategoryDecorator < Wallaby::ResourceDecorator
    self.model_class = Category
  end
end
