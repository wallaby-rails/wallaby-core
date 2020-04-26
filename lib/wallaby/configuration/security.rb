# frozen_string_literal: true

module Wallaby
  class Configuration
    # @deprecated
    # Security configuration
    # TODO: remove this from 0.3
    class Security
      # Default block to return nil for current user
      DEFAULT_CURRENT_USER = -> { nil }
      # Default block to return nil
      DEFAULT_AUTHENTICATE = -> { true }

      # @deprecated
      # @!attribute [r] logout_path
      # @see Wallaby::Configurable::ClassMethods#logout_path
      # @since wallaby-5.1.4
      attr_reader :logout_path

      # @!attribute [w] logout_path
      def logout_path=(logout_path)
        Deprecator.alert 'config.security.logout_path=', from: '0.3', alternative: <<~INSTRUCTION
          Please use #logout_path= from the controller instead, for example:

            class Admin::ApplicationController < Wallaby::ResourcesController
              self.logout_path = 'destroy_admin_user_session_path'
            end
        INSTRUCTION

        @logout_path = logout_path
      end

      # @deprecated
      # @!attribute [r] logout_method
      # @see Wallaby::Configurable::ClassMethods#logout_method
      # @since wallaby-5.1.4
      attr_reader :logout_method

      # @!attribute [w] logout_method
      def logout_method=(logout_method)
        Deprecator.alert 'config.security.logout_method=', from: '0.3', alternative: <<~INSTRUCTION
          Please use #logout_method= from the controller instead, for example:

          class Admin::ApplicationController < Wallaby::ResourcesController
            self.logout_method = 'put'
          end
        INSTRUCTION

        @logout_method = logout_method
      end

      # @deprecated
      # @!attribute [r] email_method
      # @see Wallaby::Configurable::ClassMethods#email_method
      # @since wallaby-5.1.4
      attr_reader :email_method

      # @!attribute [w] email_method
      def email_method=(email_method)
        Deprecator.alert 'config.security.email_method=', from: '0.3', alternative: <<~INSTRUCTION
          Please use #email_method= from the controller instead, for example:

            class Admin::ApplicationController < Wallaby::ResourcesController
              self.email_method = 'email_address'
            end
        INSTRUCTION

        @email_method = email_method
      end

      # @deprecated
      # To globally configure how to get user object.
      # @example To update how to get the current user object in `config/initializers/wallaby.rb`
      #   Wallaby.config do |config|
      #     config.security.current_user do
      #       User.find_by_email session[:user_email]
      #     end
      #   end
      # @yield A block to get user object. All application controller methods can be used in the block.
      def current_user(&block) # rubocop:disable Metrics/MethodLength
        Deprecator.alert 'config.security.current_user', from: '0.3', alternative: <<~INSTRUCTION
          Please change #wallaby_user from the controller instead, for example:

            class Admin::ApplicationController < Wallaby::ResourcesController
              def wallaby_user
                User.find_by_email session[:user_email]
              end
            end
        INSTRUCTION

        if block_given?
          @current_user = block
        else
          @current_user ||= DEFAULT_CURRENT_USER
        end
      end

      # Check if {#current_user} configuration is set.
      # @return [Boolean]
      def current_user?
        current_user != DEFAULT_CURRENT_USER
      end

      # @deprecated
      # To globally configure how to authenicate a user.
      # @example
      #   Wallaby.config do |config|
      #     config.security.authenticate do
      #       authenticate_or_request_with_http_basic do |username, password|
      #         username == 'too_simple' && password == 'too_naive'
      #       end
      #     end
      #   end
      # @yield A block to authenticate user. All application controller methods can be used in the block.
      def authenticate(&block) # rubocop:disable Metrics/MethodLength
        Deprecator.alert 'config.security.authenticate', from: '0.3', alternative: <<~INSTRUCTION
          Please change #authenticate_wallaby_user! from the controller instead, for example:

            class Admin::ApplicationController < Wallaby::ResourcesController
              def authenticate_wallaby_user!
                authenticate_or_request_with_http_basic do |username, password|
                  username == 'too_simple' && password == 'too_naive'
                end
              end
            end
        INSTRUCTION

        if block_given?
          @authenticate = block
        else
          @authenticate ||= DEFAULT_AUTHENTICATE
        end
      end

      # @deprecated
      # Check if {#authenticate} configuration is set.
      # @return [Boolean]
      def authenticate?
        authenticate != DEFAULT_AUTHENTICATE
      end
    end
  end
end
