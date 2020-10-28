# frozen_string_literal: true

module Wallaby
  # Convert strings
  class Inflector
    class << self
      # @param name [String]
      # @return [String] class name
      def classify(name)
        name.gsub(COLONS, SLASH).classify
      end

      # @param script_name [String]
      # @param resources_name [String,nil]
      # @return [String] class name
      def to_controller_name(script_name, resources_name)
        controller_name =
          "#{script_name}/#{resources_name}_controller"
          .gsub(%r{\A/+}, '') # remove the leading slashes
        classify(controller_name)
      end

      # @param model_class [Class, String]
      # @return [String] resources name
      def to_resources_name(model_class)
        return EMPTY_STRING if model_class.blank?

        ActiveSupport::Inflector.tableize(model_class.to_s).gsub(SLASH, COLONS)
      end
    end
  end
end
