# frozen_string_literal: true

module Wallaby
  # This is the base authorizer class to provider authorization for given/associated model.
  #
  # For best practice, please create an application authorizer class (see example)
  # to better control the functions shared between different model authorizers.
  # @example Create an application class for Admin Interface usage
  #   class Admin::ApplicationAuthorizer < Wallaby::ModelAuthorizer
  #     base_class!
  #   end
  # @since wallaby-5.2.0
  class ModelAuthorizer
    extend Baseable::ClassMethods
    base_class!

    class << self
      # @!attribute [w] provider_name
      attr_writer :provider_name

      # @!attribute [r] provider_name
      # @return [String, Symbol] provider name of the authorization framework used
      def provider_name
        @provider_name ||= superclass.try :provider_name
      end
    end

    delegate(*ModelAuthorizationProvider.instance_methods(false), to: :@provider)

    # @!attribute [r] model_class
    # @return [Class]
    attr_reader :model_class

    # @!attribute [r] provider
    # @return [Wallaby::ModelAuthorizationProvider] the instance that does the job
    # @since wallaby-5.2.0
    attr_reader :provider

    # @!attribute [r] context
    # @return [ActionController::Base, ActionView::Base]
    # @since 0.2.2
    attr_reader :context

    # @param model_class [Class]
    # @param context [ActionController::Base, ActionView::Base]
    def initialize(model_class, context)
      @model_class = model_class || self.class.model_class
      @context = context
      @provider = guess_provider_from(context)
    end

    protected

    # Go through the provider list and find out the one is
    # {Wallaby::ModelAuthorizationProvider.available? .available?}
    # @param context [ActionController::Base, ActionView::Base]
    def guess_provider_from(context)
      provider_class =
        Map.authorizer_provider_map(model_class).try do |providers|
          providers[self.class.provider_name] \
            || providers.values.find { |klass| klass.available? context } \
            || providers[:default] # fallback to default
        end
      provider_class.new context
    end
  end
end
