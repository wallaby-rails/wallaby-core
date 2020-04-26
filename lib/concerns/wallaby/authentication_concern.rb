# frozen_string_literal: true

module Wallaby
  # Authentication related functions
  module AuthenticationConcern
    extend ActiveSupport::Concern

    included do
      helper_method :wallaby_user

      rescue_from NotAuthenticated, with: :unauthorized
      rescue_from Forbidden, with: :forbidden
    end

    # @deprecated Use {#wallaby_user} instead
    # @note This is a template method that can be overridden by subclasses
    # This {current_user} method will try to looking up the actual implementation from the following
    # places from high precedence to low:
    #
    # - {Wallaby::Configuration::Security#current_user}
    # - `super`
    # - do nothing
    #
    # It can be replaced completely in subclasses:
    #
    #   def current_user
    #     # NOTE: please ensure `@current_user` is assigned, for instance:
    #     @current_user ||= User.new params.slice(:email)
    #   end
    # @return [Object] a user object
    def current_user
      # TODO: remove this from 0.3
      @current_user ||=
        if security.current_user? || !defined? super
          instance_exec(&security.current_user)
        else
          Deprecator.alert method(:current_user), from: '0.3', alternative: method(:wallaby_user)
          super
        end
    end

    # @deprecated Use {#authenticate_wallaby_user!} instead
    # @note This is a template method that can be overridden by subclasses
    # This {authenticate_user!} method will try to looking up the actual implementation from the following
    # places from high precedence to low:
    #
    # - {Wallaby::Configuration::Security#authenticate}
    # - `super`
    # - do nothing
    #
    # It can be replaced completely in subclasses:
    #
    #   def authenticate_user!
    #     authenticate_or_request_with_http_basic do |username, password|
    #       username == 'too_simple' && password == 'too_naive'
    #     end
    #   end
    # @return [true] when user is authenticated successfully
    # @raise [Wallaby::NotAuthenticated] when user fails to authenticate
    def authenticate_user!
      # TODO: remove this from 0.3
      authenticated =
        if security.authenticate? || !defined? super
          instance_exec(&security.authenticate)
        else
          Deprecator.alert method(:authenticate_user!), from: '0.3', alternative: method(:authenticate_wallaby_user!)
          super
        end
      raise NotAuthenticated if authenticated == false

      true
    end

    # @note This is a template method that can be overridden by subclasses
    # This method will try to call {#current_user} from superclass.
    # @example It can be overridden in subclasses:
    #   def wallaby_user
    #     # NOTE: better to assign user to `@wallaby_user` for better performance:
    #     @wallaby_user ||= User.new params.slice(:email)
    #   end
    # @return [Object] a user object
    def wallaby_user
      @wallaby_user ||= try :current_user
    end

    # @note This is a template method that can be overridden by subclasses
    # This method will try to call {#authenticate_user!} from superclass.
    # And it will be run as the first callback before an action.
    # @example It can be overridden in subclasses:
    #   def authenticate_wallaby_user!
    #     authenticate_or_request_with_http_basic do |username, password|
    #       username == 'too_simple' && password == 'too_naive'
    #     end
    #   end
    # @return [true] when user is authenticated successfully
    # @raise [Wallaby::NotAuthenticated] when user fails to authenticate
    def authenticate_wallaby_user!
      authenticated = try :authenticate_user!
      raise NotAuthenticated if authenticated == false

      true
    end

    # Unauthorized page.
    # @param exception [Exception] comes from **rescue_from**
    def unauthorized(exception = nil)
      render_error exception, __callee__
    end

    # Forbidden page.
    # @param exception [Exception] comes from **rescue_from**
    def forbidden(exception = nil)
      render_error exception, __callee__
    end
  end
end
