# frozen_string_literal: true

module Wallaby
  # @note This authorization provider DOES NOT use the
  #   {https://github.com/varvet/pundit#customize-pundit-user pundit_user} helper.
  #   It uses the one from {Wallaby::AuthenticationConcern#wallaby_user #wallaby_user} instead.
  # {https://github.com/varvet/pundit Pundit} base authorization provider.
  class PunditAuthorizationProvider < ModelAuthorizationProvider
    # Detect and see if Pundit is in use.
    # @param context [ActionController::Base]
    # @return [true] if Pundit is in use
    # @return [false] otherwise
    def self.available?(context)
      defined?(Pundit) && context.respond_to?(:pundit_user)
    end

    # Check user's permission for an action on given subject.
    #
    # This method will be mostly used in controller.
    # @param action [Symbol, String]
    # @param subject [Object, Class]
    # @raise [Wallaby::Forbidden] when user is not authorized to perform the action.
    def authorize(action, subject)
      Pundit.authorize(user, subject, normalize(action)) && subject
    rescue ::Pundit::NotAuthorizedError
      Logger.error <<~MESSAGE
        #{user.class}##{user.id} tried to perform #{action} on #{subject.class}##{subject.id}
      MESSAGE
      raise Forbidden
    end

    # Check and see if user is allowed to perform an action on given subject
    # @param action [Symbol, String]
    # @param subject [Object, Class]
    # @return [true] if user is allowed to perform the action
    # @return [false] otherwise
    def authorized?(action, subject)
      policy = Pundit.policy! user, subject
      policy.try normalize(action)
    end

    # Restrict user to assign certain values.
    #
    # It will do a lookup in policy's methods and pick the first available method:
    #
    # - `attributes_for_#{action}`
    # - `attributes_for`
    # @param action [Symbol, String]
    # @param subject [Object]
    # @return [Hash] field value paired hash that user's allowed to assign
    def attributes_for(action, subject)
      policy = Pundit.policy! user, subject
      policy.try("attributes_for_#{action}") || policy.try('attributes_for') || {}
    end

    # Restrict user for mass assignment.
    #
    # It will do a lookup in policy's methods and pick the first available method:
    #
    # - `permitted_attributes_for_#{ action }`
    # - `permitted_attributes`
    # @param action [Symbol, String]
    # @param subject [Object]
    # @return [Array] field list that user's allowed to change.
    def permit_params(action, subject)
      policy = Pundit.policy! user, subject
      # @see https://github.com/varvet/pundit/blob/master/lib/pundit.rb#L258
      policy.try("permitted_attributes_for_#{action}") || policy.try('permitted_attributes')
    end

    protected

    # Convert action to pundit method name
    # @param action [Symbol, String]
    # @return [String] e.g. `create?`
    def normalize(action)
      "#{action}?".tr('??', '?')
    end
  end
end
