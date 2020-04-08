# frozen_string_literal: true

module Wallaby
  # Model servicer contains resourceful operations for Rails resourceful actions.
  class ModelServicer
    extend Baseable::ClassMethods
    base_class!

    # @!attribute [r] model_class
    # @return [Class]
    attr_reader :model_class

    # @!attribute [r] model_decorator
    # @return [Wallaby::ModelDecorator]
    # @since wallaby-5.2.0
    attr_reader :model_decorator

    # @!attribute [r] authorizer
    # @return [Wallaby::ModelAuthorizer]
    # @since wallaby-5.2.0
    attr_reader :authorizer

    # @!attribute [r] provider
    # @return [Wallaby::ModelServiceProvider]
    # @since wallaby-5.2.0
    attr_reader :provider

    # @!method user
    # @return [Object]
    # @since wallaby-5.2.0
    delegate :user, to: :authorizer

    # During initialization, Wallaby will assign a service provider for this servicer
    # to carry out the actual execution.
    #
    # Therefore, all its actions can be completely replaced by user's own implemnetation.
    # @param model_class [Class]
    # @param authorizer [Wallaby::ModelAuthorizer]
    # @param model_decorator [Wallaby::ModelDecorator]
    # @raise [ArgumentError] if param model_class is blank
    def initialize(model_class, authorizer, model_decorator = nil)
      @model_class = model_class || self.class.model_class
      raise ArgumentError, Locale.t('errors.required', subject: 'model_class') unless @model_class

      @model_decorator = model_decorator || Map.model_decorator_map(model_class)
      @authorizer = authorizer
      provider_class = Map.service_provider_map(@model_class)
      @provider = provider_class.new(@model_class, @model_decorator)
    end

    # @note This is a template method that can be overridden by subclasses.
    # Whitelist parameters for mass assignment.
    # @param params [ActionController::Parameters, Hash]
    # @param action [String, Symbol]
    # @return [ActionController::Parameters] permitted params
    def permit(params, action = nil)
      provider.permit params, action, authorizer
    end

    # @note This is a template method that can be overridden by subclasses.
    # Return a collection by querying the datasource (e.g. database, REST API).
    # @param params [ActionController::Parameters, Hash]
    # @return [Enumerable] list of records
    def collection(params)
      provider.collection params, authorizer
    end

    # @!method paginate(query, params)
    # @note This is a template method that can be overridden by subclasses.
    # Paginate given {#collection}.
    # @param query [Enumerable]
    # @param params [ActionController::Parameters]
    # @return [Enumerable] list of records
    delegate :paginate, to: :provider

    # @note This is a template method that can be overridden by subclasses.
    # Initialize an instance of the model class.
    # @param params [ActionController::Parameters]
    # @return [Object] initialized object
    def new(params)
      provider.new params, authorizer
    end

    # @note This is a template method that can be overridden by subclasses.
    # To find a record.
    # @param id [Object]
    # @param params [ActionController::Parameters]
    # @return [Object] resource object
    def find(id, params)
      provider.find id, params, authorizer
    end

    # @note This is a template method that can be overridden by subclasses.
    # To create a record.
    # @param resource [Object]
    # @param params [ActionController::Parameters]
    # @return [Object] resource object
    def create(resource, params)
      provider.create resource, params, authorizer
    end

    # @note This is a template method that can be overridden by subclasses.
    # To update a record.
    # @param resource [Object]
    # @param params [ActionController::Parameters]
    # @return [Object] resource object
    def update(resource, params)
      provider.update resource, params, authorizer
    end

    # @note This is a template method that can be overridden by subclasses.
    # To delete a record.
    # @param resource [Object]
    # @param params [ActionController::Parameters]
    # @return [Object] resource object
    def destroy(resource, params)
      provider.destroy resource, params, authorizer
    end
  end
end
