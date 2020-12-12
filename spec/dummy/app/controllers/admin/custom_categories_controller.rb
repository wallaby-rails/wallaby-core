module Admin
  # Ordinary controller setup for spec/features/custom_routes_and_controllers_spec.rb
  class CustomCategoriesController < Admin::ApplicationController
    self.model_class = Category

    def member_only
      render plain: "This is a member only action for #{self.class.name}"
    end

    def collection_only
      render plain: "This is a collection only action for #{self.class.name}"
    end

    def links
      render json: {
        category: {
          index: index_path(Category),
          new: new_path(Category),
          show: show_path(Category.new(id: 1)),
          edit: edit_path(Category.new(id: 1))
        },
        product: {
          index: index_path(Product),
          new: new_path(Product),
          show: show_path(Product.new(id: 1)),
          edit: edit_path(Product.new(id: 1))
        }
      }
    end
  end
end
