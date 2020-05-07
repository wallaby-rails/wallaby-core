# frozen_string_literal: true

module Wallaby
  class Engine
    # `wallaby:engine:decorator` generator
    class DecoratorGenerator < Rails::Generators::NamedBase
      source_root File.expand_path('templates', __dir__)
      argument :name, type: :string
      argument :parent_name, type: :string, default: nil, required: false

      # @see https://github.com/wallaby-rails/wallaby-core/blob/master/lib/generators/wallaby/engine/decorator/USAGE
      def install
        template 'decorator.rb.erb', "app/decorators/#{name}_decorator.rb"
      end

      protected

      def decorator_class
        "#{class_name}Decorator"
      end

      def parent_decorator_class
        return "#{parent_name.classify}Decorator" if parent_name

        Wallaby.configuration.resources_controller.application_decorator
      end

      def model_name
        class_name.singularize
      end
    end
  end
end
