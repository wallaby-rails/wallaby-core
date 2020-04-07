# frozen_string_literal: true

module Wallaby
  # @note This authorization provider DOES NOT use the existing
  #   {https://www.rubydoc.info/github/CanCanCommunity/cancancan/CanCan%2FControllerAdditions:current_ability
  #   current_ability} helper. It has its own version of {#ability} instance.
  # {https://github.com/CanCanCommunity/cancancan CanCanCan} base authorization provider.
  class CancancanAuthorizationProvider < ModelAuthorizationProvider
    # Detect and see if Cancancan is in use.
    # @param context [ActionController::Base]
    # @return [true] if Cancancan is in use.
    # @return [false] if Cancancan is not in use.
    def self.available?(context)
      defined?(CanCanCan) && context.respond_to?(:current_ability)
    end

    # @return [Ability] The Ability instance for {#user #user} (which is a
    #   {Wallaby::AuthenticationConcern#wallaby_user #wallaby_user})
    def ability
      # NOTE: use current_ability's class to create the ability instance.
      # just in case that developer uses a different Ability class (e.g. UserAbility)
      @ability ||= Ability.new user
    rescue ArgumentError, NameError
      context.current_ability
    end

    # Check user's permission for an action on given subject.
    # This method will be used in controller.
    # @param action [Symbol, String]
    # @param subject [Object, Class]
    # @raise [Wallaby::Forbidden] when user is not authorized to perform the action.
    def authorize(action, subject)
      ability.authorize! action, subject
    rescue ::CanCan::AccessDenied
      Logger.info Locale.t('errors.unauthorized', user: user, action: action, subject: subject)
      raise Forbidden
    end

    # Check and see if user is allowed to perform an action on given subject.
    # @param action [Symbol, String]
    # @param subject [Object, Class]
    # @return [Boolean]
    def authorized?(action, subject)
      ability.can? action, subject
    end

    # Restrict user to access certain scope.
    # @param action [Symbol, String]
    # @param scope [Object]
    # @return [Object]
    def accessible_for(action, scope)
      scope.try(:accessible_by, ability, action) || scope
    end

    # @!method attributes_for(action, subject)
    # Restrict user to assign certain values.
    # @param action [Symbol, String]
    # @param subject [Object]
    # @return nil
    delegate :attributes_for, to: :ability

    # Just return nil as Cancancan doesn't provide similar feature.
    # @param action [Symbol, String]
    # @param subject [Object]
    # @return [nil]
    def permit_params(action, subject)
      # Do nothing
    end
  end
end
