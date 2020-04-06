# frozen_string_literal: true

module Wallaby
  # Model Authorizer to provide authorization functions
  # @since wallaby-5.2.0
  class ModelAuthorizer
    extend Baseable::ClassMethods

    class << self
      # @!attribute [w] model_class
      attr_writer :model_class

      # @!attribute [r] model_class
      # Return associated model class, e.g. return **Product** for **ProductAuthorizer**.
      #
      # If Wallaby can't recognise the model class for Authorizer, it's required to be configured as below example:
      # @example To configure model class
      #   class Admin::ProductAuthorizer < Admin::ApplicationAuthorizer
      #     self.model_class = Product
      #   end
      # @example To configure model class for version below 5.2.0
      #   class Admin::ProductAuthorizer < Admin::ApplicationAuthorizer
      #     def self.model_class
      #       Product
      #     end
      #   end
      # @return [Class] assoicated model class
      # @return [nil] if current class is marked as base class
      # @return [nil] if current class is the same as the value of {Wallaby::Configuration::Mapping#model_authorizer}
      # @return [nil] if current class is {Wallaby::ModelAuthorizer}
      # @return [nil] if assoicated model class is not found
      def model_class
        return unless self < ModelAuthorizer
        return if base_class? || self == Wallaby.configuration.mapping.model_authorizer

        @model_class ||= Map.model_class_map(name.gsub(/(^#{namespace}::)|(Authorizer$)/, EMPTY_STRING))
      end

      # @!attribute [w] provider_name
      attr_writer :provider_name

      # @!attribute [r] provider_name
      # @return [String, Symbol] provider name of the authorization framework used
      def provider_name
        @provider_name ||= ModuleUtils.try_to superclass, :provider_name
      end
    end

    delegate(*ModelAuthorizationProvider.instance_methods(false), to: :@provider)

    # @!attribute [r] model_class
    # @return [Class]
    attr_reader :model_class

    # @!attribute [r] provider
    # @return [Wallaby::ModelAuthorizationProvider]
    # @since wallaby-5.2.0
    attr_reader :provider

    # @!attribute [r] provider
    # @return [Wallaby::ModelAuthorizationProvider]
    # @since 0.2.2
    attr_reader :context

    # @param model_class [Class]
    # @param context [ActionController::Base]
    def initialize(model_class, context, provider_class: nil)
      @model_class = model_class || self.class.model_class
      @context = context
      @provider = provider_class || guess_provider_from(context)
    end

    protected

    def guess_provider_from(context)
      provider_class = begin
        providers = Map.authorizer_provider_map model_class
        providers[self.class.provider_name] || providers.values.find { |klass| klass.available? context }
      end
      provider_class.new context
    end
  end
end
