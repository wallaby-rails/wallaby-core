# frozen_string_literal: true

module Wallaby
  # Authorizer related attributes
  module Authorizable
    extend ActiveSupport::Concern

    # Configurable attribute for authorizer related
    module ClassMethods
      # @!attribute [w] model_authorizer
      def model_authorizer=(model_authorizer)
        ModuleUtils.inheritance_check model_authorizer, application_authorizer
        @model_authorizer = model_authorizer
      end

      # @!attribute [r] model_authorizer
      # If Wallaby doesn't get it right, please specify the **model_authorizer**.
      # @example To set model authorizer
      #   class Admin::ProductionsController < Admin::ApplicationController
      #     self.model_authorizer = ProductAuthorizer
      #   end
      # @return [Class] model authorizer
      # @raise [ArgumentError] when **model_authorizer** doesn't inherit from **application_authorizer**
      # @see Wallaby::ModelAuthorizer
      # @since wallaby-5.2.0
      attr_reader :model_authorizer

      # @!attribute [w] application_authorizer
      def application_authorizer=(application_authorizer)
        ModuleUtils.inheritance_check model_authorizer, application_authorizer
        @application_authorizer = application_authorizer
      end

      # @!attribute [r] application_authorizer
      # The **application_authorizer** is as the base class of {#model_authorizer}.
      # @example To set application decorator:
      #   class Admin::ApplicationController < Wallaby::ResourcesController
      #     self.application_authorizer = AnotherApplicationAuthorizer
      #   end
      # @return [Class] application decorator
      # @raise [ArgumentError] when **model_authorizer** doesn't inherit from **application_authorizer**
      # @see Wallaby::ModelAuthorizer
      # @since wallaby-5.2.0
      def application_authorizer
        @application_authorizer ||= superclass.try :application_authorizer
      end
    end

    # Model authorizer for current modal class.
    #
    #  It can be configured in following class attributes:
    #
    # - controller configuration {Wallaby::Authorizable::ClassMethods#model_authorizer .model_authorizer}
    # - a generic authorizer based on
    #   {Wallaby::Authorizable::ClassMethods#application_authorizer .application_authorizer}
    # @return [Wallaby::ModelAuthorizer] model authorizer
    # @since wallaby-5.2.0
    def current_authorizer
      @current_authorizer ||=
        authorizer_of(current_model_class, controller_to_get(:model_authorizer)).tap do |authorizer|
          Logger.debug %(Current authorizer: #{authorizer.try(:class)}), sourcing: false
        end
    end

    # Check if user is allowed to perform action on given subject
    # @param action [Symbol, String]
    # @param subject [Object, Class]
    # @return [true] if allowed
    # @return [false] if not allowed
    # @since wallaby-5.2.0
    def authorized?(action, subject)
      return false unless subject

      klass = subject.is_a?(Class) ? subject : subject.class
      authorizer_of(klass).authorized? action, subject
    end

    # Check if user is allowed to perform action on given subject
    # @param action [Symbol, String]
    # @param subject [Object, Class]
    # @return [true] if not allowed
    # @return [false] if allowed
    # @since wallaby-5.2.0
    def unauthorized?(action, subject)
      !authorized? action, subject
    end

    protected

    # @param model_class [Class]
    # @param authorizer_class [Class, nil]
    # @return [Wallaby::ModelAuthorizer] model authorizer for given model
    # @since wallaby-5.2.0
    def authorizer_of(model_class, authorizer_class = nil)
      authorizer_class ||= Map.authorizer_map(model_class, controller_to_get(:application_authorizer))
      authorizer_class.new model_class, self
    end
  end
end
