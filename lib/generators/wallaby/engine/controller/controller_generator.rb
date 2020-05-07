# frozen_string_literal: true

module Wallaby
  class Engine
    # `wallaby:engine:controller` generator
    class ControllerGenerator < Rails::Generators::NamedBase
      source_root File.expand_path('templates', __dir__)
      argument :name, type: :string
      argument :parent_name, type: :string, default: nil, required: false

      # @see https://github.com/wallaby-rails/wallaby-core/blob/master/lib/generators/wallaby/engine/controller/USAGE
      def install
        template 'controller.rb.erb', "app/controllers/#{name}_controller.rb"
      end

      protected

      def controller_class
        "#{class_name}Controller"
      end

      def parent_controller_class
        parent_name ? "#{parent_name.classify}Controller" : Wallaby.configuration.resources_controller
      end

      def model_name
        class_name.singularize
      end
    end
  end
end
