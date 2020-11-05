module Admin
  # Ordinary controller setup for spec/features/custom_routes_and_controllers_spec.rb
  class CategoriesController < Admin::ApplicationController
    def member_only
      render plain: "This is a member only action for #{self.class.name}"
    end

    def collection_only
      render plain: "This is a collection only action for #{self.class.name}"
    end

    def links
      render json: {
        index: index_path(Category),
        new: new_path(Category),
        show: show_path(Category.new(id: 1)),
        edit: edit_path(Category.new(id: 1))
      }
    end
  end
end
