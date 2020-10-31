# frozen_string_literal: true

module Wallaby
  # Convert strings
  module Inflector
    extend self

    # @param name [String]
    # @return [String] class name
    # @return [nil] if name is blank
    def to_class_name(name)
      return EMPTY_STRING if name.blank?

      name = name.to_s unless name.is_a?(String)
      name.gsub(COLONS, SLASH).classify
    end

    # @param script_name [String]
    # @param resources_name [String,nil]
    # @return [String] normalized string ready for {#classify}
    def to_script(script_name, resources_name, suffix = EMPTY_STRING)
      "#{script_name}/#{resources_name}#{suffix}".gsub(%r{\A/+}, EMPTY_STRING)
    end

    # @param script_name [String]
    # @param resources_name [String,nil]
    # @return [String] controller name
    def to_controller_name(script_name, resources_name)
      to_class_name(to_script(script_name, resources_name, "_controller"))
    end

    # @param script_name [String]
    # @param resources_name [String,nil]
    # @return [String] authorizer name
    def to_authorizer_name(script_name, resources_name)
      to_class_name(to_script(script_name, resources_name.singularize, "_authorizer"))
    end

    # @param name [Class, String]
    # @return [String] resources name
    def to_resources_name(name)
      return EMPTY_STRING if name.blank?

      name = name.to_s unless name.is_a?(String)
      name.tableize.gsub(SLASH, COLONS)
    end
  end
end
