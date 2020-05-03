# frozen_string_literal: true

module Wallaby
  # Decorator related attributes
  module Decoratable
    # Get current model decorator. It comes from
    #
    # - model decorator for {Wallaby::Configurable::ClassMethods#resource_decorator resource_decorator}
    # - otherwise, model decorator for {Wallaby::Configurable::ClassMethods#application_decorator application_decorator}
    #
    # Model decorator stores the information of **metadata** and **field_names** for **index**/**show**/**form** action.
    # @return [Wallaby::ModelDecorator] current model decorator for this request
    def current_model_decorator
      @current_model_decorator ||=
        current_decorator.try(:model_decorator) || \
        Map.model_decorator_map(current_model_class, controller_configuration.application_decorator)
    end

    # Get current resource decorator. It comes from
    #
    # - {Wallaby::Configurable::ClassMethods#resource_decorator resource_decorator}
    # - otherwise, {Wallaby::Configurable::ClassMethods#application_decorator application_decorator}
    # @return [Wallaby::ResourceDecorator] current resource decorator for this request
    def current_decorator
      @current_decorator ||=
        (
          controller_configuration.resource_decorator || \
          Map.resource_decorator_map(
            current_model_class, controller_configuration.application_decorator
          )
        ).tap do |decorator|
          Logger.debug %(Current decorator: #{decorator}), sourcing: false
        end
    end

    # Get current fields metadata for current action name.
    # @return [Hash] current fields metadata
    def current_fields
      @current_fields ||=
        current_model_decorator.try(:"#{action_name}_fields")
    end

    # Wrap resource(s) with decorator(s).
    # @param resource [Object, Enumerable]
    # @return [Wallaby::ResourceDecorator, Enumerable<Wallaby::ResourceDecorator>] decorator(s)
    def decorate(resource)
      return resource if resource.is_a? ResourceDecorator
      return resource.map { |item| decorate item } if resource.respond_to? :map

      decorator = Map.resource_decorator_map resource.class, controller_configuration.application_decorator
      decorator ? decorator.new(resource) : resource
    end

    # @param resource [Object, Wallaby::ResourceDecorator]
    # @return [Object] the unwrapped resource object
    def extract(resource)
      return resource.resource if resource.is_a? ResourceDecorator

      resource
    end
  end
end
