# frozen_string_literal: true

module Wallaby
  class Engine
    # `wallaby:engine:servicer` generator
    class ServicerGenerator < Rails::Generators::NamedBase
      source_root File.expand_path('templates', __dir__)
      argument :name, type: :string
      argument :parent_name, type: :string, default: nil, required: false

      # @see https://github.com/wallaby-rails/wallaby-core/blob/master/lib/generators/wallaby/engine/servicer/USAGE
      def install
        template 'servicer.rb.erb', "app/servicers/#{name}_servicer.rb"
      end

      protected

      def servicer_class
        "#{class_name}Servicer"
      end

      def parent_servicer_class
        return "#{parent_name.classify}Servicer" if parent_name

        Wallaby.configuration.resources_controller.application_servicer
      end

      def model_name
        class_name.singularize
      end
    end
  end
end
