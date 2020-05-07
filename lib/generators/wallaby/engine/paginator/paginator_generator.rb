# frozen_string_literal: true

module Wallaby
  class Engine
    # `wallaby:engine:paginator` generator
    class PaginatorGenerator < Rails::Generators::NamedBase
      source_root File.expand_path('templates', __dir__)
      argument :name, type: :string
      argument :parent_name, type: :string, default: nil, required: false

      # @see https://github.com/wallaby-rails/wallaby-core/blob/master/lib/generators/wallaby/engine/paginator/USAGE
      def install
        template 'paginator.rb.erb', "app/paginators/#{name}_paginator.rb"
      end

      protected

      def paginator_class
        "#{class_name}Paginator"
      end

      def parent_paginator_class
        return "#{parent_name.classify}Paginator" if parent_name

        Wallaby.configuration.resources_controller.application_paginator
      end

      def model_name
        class_name.singularize
      end
    end
  end
end
