# frozen_string_literal: true

module Wallaby
  # Authentication related functions
  module AuthenticationConcern
    extend ActiveSupport::Concern

    # @deprecated Use {#wallaby_user} instead
    # @!method current_user
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

    # @deprecated Use {#authenticate_wallaby_user!} instead
    # @!method authenticate_user!
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

    # @!method wallaby_user
    # @note This is a template method that can be overridden by subclasses
    # This method will try to call {#current_user} from superclass.
    # @example It can be overridden in subclasses:
    #   def wallaby_user
    #     # NOTE: better to assign user to `@wallaby_user` for better performance:
    #     @wallaby_user ||= User.new params.slice(:email)
    #   end
    # @return [Object] a user object

    # @!method authenticate_wallaby_user!
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

    # @!method unauthorized(exception = nil)
    # Unauthorized page.
    # @param exception [Exception] comes from **rescue_from**

    # @!method forbidden(exception = nil)
    # Forbidden page.
    # @param exception [Exception] comes from **rescue_from**

    included do # rubocop:disable Metrics/BlockLength
      helper SecureHelper
      helper_method :current_user

      rescue_from NotAuthenticated, with: :unauthorized
      rescue_from Forbidden, with: :forbidden

      # (see #current_user)
      def current_user
        @current_user ||=
          if security.current_user? || !defined? super
            instance_exec(&security.current_user)
          else
            Logger.deprecated 'Wallaby will use `wallaby_user` instead of `current_user` from 6.2.'
            super
          end
      end

      # (see #authenticate_user!)
      def authenticate_user!
        authenticated =
          if security.authenticate? || !defined? super
            instance_exec(&security.authenticate)
          else
            Logger.deprecated 'Wallaby will use `authenticate_wallaby_user!`' \
              'instead of `authenticate_user!` from 6.2.'
            super
          end
        raise NotAuthenticated if authenticated == false

        true
      end

      # (see #wallaby_user)
      def wallaby_user
        @wallaby_user ||= try :current_user
      end

      # (see #authenticate_wallaby_user!)
      def authenticate_wallaby_user!
        authenticated = try :authenticate_user!
        raise NotAuthenticated if authenticated == false

        true
      end

      # (see #unauthorized)
      def unauthorized(exception = nil)
        render_error exception, __callee__
      end

      # (see #forbidden)
      def forbidden(exception = nil)
        render_error exception, __callee__
      end
    end
  end
end
