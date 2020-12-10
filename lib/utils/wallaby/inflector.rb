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
    # @param resources_name [Class,String,nil]
    # @return [String] generate the prefix for all classes
    def to_script(script_name, resources_name, suffix = nil)
      normalized_suffix = suffix.try(:underscore).try(:gsub, /\A_?/, UNDERSCORE)
      "#{script_name}/#{resources_name}#{normalized_suffix}".gsub(%r{\A/+}, EMPTY_STRING)
    end

    # @param script_name [String]
    # @param resources_name [String,nil]
    # @return [String] controller name
    def to_controller_name(script_name, resources_name)
      to_class_name(to_script(script_name, to_resources_name(resources_name), CONTROLLER))
    end

    # @param script_name [String]
    # @param resources_name [String,nil]
    # @return [String] decorator name
    def to_decorator_name(script_name, resources_name)
      to_class_name(to_script(script_name, to_resource_name(resources_name), DECORATOR))
    end

    # @param script_name [String]
    # @param resources_name [String,nil]
    # @return [String] authorizer name
    def to_authorizer_name(script_name, resources_name)
      to_class_name(to_script(script_name, to_resource_name(resources_name), AUTHORIZER))
    end

    # @param script_name [String]
    # @param resources_name [String,nil]
    # @return [String] servicer name
    def to_servicer_name(script_name, resources_name)
      to_class_name(to_script(script_name, to_resource_name(resources_name), SERVICER))
    end

    # @param script_name [String]
    # @param resources_name [String,nil]
    # @return [String] paginator name
    def to_paginator_name(script_name, resources_name)
      to_class_name(to_script(script_name, to_resource_name(resources_name), PAGINATOR))
    end

    # @param name [Class, String]
    # @return [String] resources name
    def to_resource_name(name)
      return EMPTY_STRING if name.blank?

      name = name.to_s unless name.is_a?(String)
      name.underscore.singularize.gsub(SLASH, COLONS)
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
