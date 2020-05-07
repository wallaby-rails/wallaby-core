# frozen_string_literal: true

module Wallaby
  class Engine
    # `wallaby:engine:authorizer` generator
    class AuthorizerGenerator < Rails::Generators::NamedBase
      source_root File.expand_path('templates', __dir__)
      argument :name, type: :string
      argument :parent_name, type: :string, default: nil, required: false

      # @see https://github.com/wallaby-rails/wallaby-core/blob/master/lib/generators/wallaby/engine/authorizer/USAGE
      def install
        template 'authorizer.rb.erb', "app/authorizers/#{name}_authorizer.rb"
      end

      protected

      def authorizer_class
        "#{class_name}Authorizer"
      end

      def parent_authorizer_class
        return "#{parent_name.classify}Authorizer" if parent_name

        Wallaby.configuration.resources_controller.application_authorizer
      end

      def model_name
        class_name.singularize
      end
    end
  end
end
