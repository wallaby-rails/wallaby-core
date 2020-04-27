# frozen_string_literal: true

module Wallaby
  # Authorizer related attributes
  module Authorizable
    # Model authorizer for current modal class.
    #
    #  It can be configured in following class attributes:
    #
    # - controller configuration {Wallaby::Configurable::ClassMethods#model_authorizer .model_authorizer}
    # - a generic authorizer based on
    #   {Wallaby::Configurable::ClassMethods#application_authorizer .application_authorizer}
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
