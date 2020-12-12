# frozen_string_literal: true

module Wallaby
  # Decorator base class. It's designed to be used as the decorator (AKA presenter/view object)
  # for the associated model instance (which means it should be used in the views only).
  #
  # And it holds the following metadata information for associated model class:
  #
  # - {#fields}
  # - {#field_names}
  # - {#index_fields}
  # - {#index_field_names}
  # - {#show_fields}
  # - {#show_field_names}
  # - {#form_fields}
  # - {#form_field_names}
  #
  # For better practice, please create an application decorator class (see example)
  # to better control the functions shared between different resource decorators.
  # @example Create an application class for Admin Interface usage
  #   class Admin::ApplicationDecorator < Wallaby::ResourceDecorator
  #     base_class!
  #   end
  class ResourceDecorator
    extend Baseable::ClassMethods
    base_class!

    # @!attribute fields
    #   (see Wallaby::ModelDecorator#fields)

    # @!attribute field_names
    #   (see Wallaby::ModelDecorator#field_names)

    # @!attribute index_fields
    #   (see Wallaby::ModelDecorator#index_fields)

    # @!attribute index_field_names
    #   (see Wallaby::ModelDecorator#index_field_names)

    # @!attribute show_fields
    #   (see Wallaby::ModelDecorator#show_fields)

    # @!attribute show_field_names
    #   (see Wallaby::ModelDecorator#show_field_names)

    # @!attribute form_fields
    #   (see Wallaby::ModelDecorator#form_fields)

    # @!attribute form_field_names
    #   (see Wallaby::ModelDecorator#form_field_names)

    DELEGATE_METHODS =
      ModelDecorator.public_instance_methods(false) + Fieldable.public_instance_methods(false) - %i(model_class)

    class << self
      delegate(*DELEGATE_METHODS, to: :model_decorator, allow_nil: true)

      # Return associated model decorator. It is the instance that pull out all the metadata
      # information for the associated model.
      # @param model_class [Class]
      # @return [ModelDecorator]
      # @return [nil] if itself is a base class or the given model_class is blank
      def model_decorator(model_class = self.model_class)
        return if model_class.blank?

        Map.model_decorator_map(model_class, base_class)
      end

      # @!attribute [w] h
      attr_writer :h

      # @!attribute [r] h
      # @return [ActionView::Base]
      #   {Configuration::Mapping#resources_controller resources controller}'s helpers
      def h
        @h ||= Wallaby.configuration.resources_controller.helpers
      end
    end

    # @!attribute [r] resource
    # @return [Object]
    attr_reader :resource

    # @!attribute [r] model_decorator
    # @return [ModelDecorator]
    attr_reader :model_decorator

    # @return [ActionView::Base]
    #   {Configuration::Mapping#resources_controller resources controller}'s helpers
    # @see .h
    def h
      self.class.h
    end

    delegate(*DELEGATE_METHODS, to: :model_decorator)
    # NOTE: this delegation is to make url helper method working properly with resource decorator instance
    delegate :to_s, :to_param, to: :resource

    # @param resource [Object]
    def initialize(resource)
      @resource = resource
      @model_decorator = self.class.model_decorator(model_class)
    end

    # @return [Class] resource's class
    def model_class
      resource.class
    end

    # @param field_name [String, Symbol]
    # @return [Object] value of given field name
    def value_of(field_name)
      return unless field_name

      resource.try field_name
    end

    # Guess the title for given resource.
    #
    # It falls back to primary key value when no text field is found.
    # @return [String] a label
    def to_label
      # NOTE: `.to_s` at the end is to ensure String is returned that won't cause any
      # issue when `#to_label` is used in a link_to block. Coz integer is ignored.
      (model_decorator.guess_title(resource) || primary_key_value).to_s
    end

    # @return [Hash, Array] validation/result errors
    def errors
      model_decorator.form_active_errors(resource)
    end

    # @return [Object] primary key value
    def primary_key_value
      resource.try primary_key
    end

    # @return [ActiveModel::Name]
    def model_name
      resource.try(:model_name) || ActiveModel::Name.new(model_class)
    end

    # @return [nil] if no primary key
    # @return [Array<String>] primary key
    def to_key
      key = resource.try primary_key
      key ? [key] : nil
    end

    # Delegate missing method to {#resource}
    def method_missing(method_id, *args, &block)
      return super unless resource.respond_to? method_id

      resource.try method_id, *args, &block
    end

    # Delegate missing method check to {#resource}
    def respond_to_missing?(method_id, _include_private)
      resource.respond_to?(method_id) || super
    end
  end
end
