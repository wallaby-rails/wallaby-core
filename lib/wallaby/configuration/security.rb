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
      def logout_path
        Deprecator.alert 'config.security.logout_path', from: '0.2.2', alternative: <<~INSTRUCTION
          Please use controller_class.logout_path instead.
        INSTRUCTION
      end

      # @!attribute [w] logout_path
      def logout_path=(_logout_path)
        Deprecator.alert 'config.security.logout_path=', from: '0.2.2', alternative: <<~INSTRUCTION
          Please use #logout_path= from the controller instead, for example:

            class Admin::ApplicationController < Wallaby::ResourcesController
              self.logout_path = 'destroy_admin_user_session_path'
            end
        INSTRUCTION
      end

      # @deprecated
      # @!attribute [r] logout_method
      # @see Wallaby::Configurable::ClassMethods#logout_method
      # @since wallaby-5.1.4
      def logout_method
        Deprecator.alert 'config.security.logout_method', from: '0.2.2', alternative: <<~INSTRUCTION
          Please use controller_class.logout_method instead.
        INSTRUCTION
      end

      # @!attribute [w] logout_method
      def logout_method=(_logout_method)
        Deprecator.alert 'config.security.logout_method=', from: '0.2.2', alternative: <<~INSTRUCTION
          Please use #logout_method= from the controller instead, for example:

          class Admin::ApplicationController < Wallaby::ResourcesController
            self.logout_method = 'put'
          end
        INSTRUCTION
      end

      # @deprecated
      # @!attribute [r] email_method
      # @see Wallaby::Configurable::ClassMethods#email_method
      # @since wallaby-5.1.4
      def email_method
        Deprecator.alert 'config.security.email_method', from: '0.2.2', alternative: <<~INSTRUCTION
          Please use controller_class.email_method instead.
        INSTRUCTION
      end

      # @!attribute [w] email_method
      def email_method=(_email_method)
        Deprecator.alert 'config.security.email_method=', from: '0.2.2', alternative: <<~INSTRUCTION
          Please use #email_method= from the controller instead, for example:

            class Admin::ApplicationController < Wallaby::ResourcesController
              self.email_method = 'email_address'
            end
        INSTRUCTION
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
      def current_user
        Deprecator.alert 'config.security.current_user', from: '0.2.2', alternative: <<~INSTRUCTION
          Please change #wallaby_user from the controller instead, for example:

            class Admin::ApplicationController < Wallaby::ResourcesController
              def wallaby_user
                User.find_by_email session[:user_email]
              end
            end
        INSTRUCTION
      end

      # Check if {#current_user} configuration is set.
      # @return [Boolean]
      def current_user?
        Deprecator.alert 'config.security.current_user?', from: '0.2.2', alternative: <<~INSTRUCTION
          Please use controller#wallaby_user instead.
        INSTRUCTION
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
      def authenticate
        Deprecator.alert 'config.security.authenticate', from: '0.2.2', alternative: <<~INSTRUCTION
          Please change #authenticate_wallaby_user! from the controller instead, for example:

            class Admin::ApplicationController < Wallaby::ResourcesController
              def authenticate_wallaby_user!
                authenticate_or_request_with_http_basic do |username, password|
                  username == 'too_simple' && password == 'too_naive'
                end
              end
            end
        INSTRUCTION
      end

      # @deprecated
      # Check if {#authenticate} configuration is set.
      # @return [Boolean]
      def authenticate?
        Deprecator.alert 'config.security.authenicate?', from: '0.2.2', alternative: <<~INSTRUCTION
          Please use controller#authenticate_wallaby_user! instead.
        INSTRUCTION
      end
    end
  end
end
