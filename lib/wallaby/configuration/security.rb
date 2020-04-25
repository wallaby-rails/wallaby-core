# frozen_string_literal: true

module Wallaby
  class Configuration
    # Security configuration
    # TODO: remove this from 6.2
    class Security
      # Default block to return nil for current user
      DEFAULT_CURRENT_USER = -> { nil }
      # Default block to return nil
      DEFAULT_AUTHENTICATE = -> { true }

      # @!attribute [r] logout_path
      # To globally configure the logout path.
      #
      # Wallaby does not implement any authentication (e.g. login/logout), therefore, logout path will be required
      # so that Wallaby knows where to navigate the user to when user clicks the logout button.
      #
      # But once it detects `Devise`, it will use the path that Devise uses without the need of configuration.
      # @example To update the logout path in `config/initializers/wallaby.rb`
      #   Wallaby.config do |config|
      #     config.security.logout_path = 'logout_path'
      #   end
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

      # @!attribute [r] logout_method
      # To globally configure the logout HTTP method.
      #
      # Wallaby does not implement any authentication (e.g. login/logout), therefore, logout method will be required
      # so that Wallaby knows how navigate the user via what HTTP method when user clicks the logout button.
      #
      # But once it detects `Devise`, it will use the HTTP method that Devise uses without the need of configuration.
      # @example To update the logout method in `config/initializers/wallaby.rb`
      #   Wallaby.config do |config|
      #     config.security.logout_method = 'post'
      #   end
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

      # @!attribute [r] email_method
      # To globally configure the method on {#current_user} to retrieve email address.
      #
      # If no configuration is given, it will attempt to call `email` on {#current_user}.
      # @example To update the email method in `config/initializers/wallaby.rb`
      #   Wallaby.config do |config|
      #     config.security.email_method = 'email_address'
      #   end
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

      # Check if {#authenticate} configuration is set.
      # @return [Boolean]
      def authenticate?
        authenticate != DEFAULT_AUTHENTICATE
      end
    end
  end
end
