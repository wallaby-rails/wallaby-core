module Admin
  # Custom controller setup for spec/features/custom_routes_and_controllers_spec.rb
  class NotLikeCategoriesController < ApplicationController
    self.model_class = Category

    def member_only
      render plain: "This is a member only action for #{self.class.name}"
    end

    def collection_only
      render plain: "This is a collection only action for #{self.class.name}"
    end
  end
end
