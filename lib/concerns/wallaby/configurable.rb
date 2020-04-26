# frozen_string_literal: true

module Wallaby
  # Configurable related class methods
  module Configurable
    extend ActiveSupport::Concern

    # Configurable related class methods
    module ClassMethods
      # Authentication related
      begin
        # @!attribute [r] logout_path
        # To configure the logout path.
        #
        # Wallaby does not implement any authentication (e.g. login/logout), therefore, logout path will be required
        # so that Wallaby knows where to navigate the user to when user clicks the logout button.
        #
        # But once it detects `Devise`, it will use the path that Devise uses without the need of configuration.
        # @example To update the logout path in `Admin::ApplicationController`
        #   class Admin::ApplicationController < Wallaby::ResourcesController
        #     self.logout_path = 'destroy_admin_user_session_path'
        #   end
        # @since 0.2.3
        def logout_path
          @logout_path ||= superclass.try :logout_path
        end

        # @!attribute [w] logout_path
        def logout_path=(logout_path)
          case logout_path
          when String, Symbol, nil
            @logout_path = logout_path
          else
            raise ArgumentError, 'Please provide a String/Symbol value or nil'
          end
        end

        # @!attribute [r] logout_method
        # To configure the logout HTTP method.
        #
        # Wallaby does not implement any authentication (e.g. login/logout), therefore, logout method will be required
        # so that Wallaby knows how navigate the user via what HTTP method when user clicks the logout button.
        #
        # But once it detects `Devise`, it will use the HTTP method that Devise uses without the need of configuration.
        # @example To update the logout method in `Admin::ApplicationController`
        #   class Admin::ApplicationController < Wallaby::ResourcesController
        #     self.logout_method = 'put'
        #   end
        # @since 0.2.3
        def logout_method
          @logout_method ||= superclass.try :logout_method
        end

        # @!attribute [w] logout_method
        def logout_method=(logout_method)
          case logout_method
          when String, Symbol, nil
            @logout_method = logout_method
          else
            raise ArgumentError, 'Please provide a String/Symbol value or nil'
          end
        end

        # @!attribute [r] email_method
        # To configure the method on
        # {Wallaby::AuthenticationConcern#wallaby_user} to retrieve email address.
        #
        # If no configuration is given, it will attempt to call `email` on
        # {Wallaby::AuthenticationConcern#wallaby_user}.
        # @example To update the email method in `Admin::ApplicationController`
        #   class Admin::ApplicationController < Wallaby::ResourcesController
        #     self.email_method = 'email_address'
        #   end
        # @since 0.2.3
        def email_method
          @email_method ||= superclass.try :email_method
        end

        # @!attribute [w] email_method
        def email_method=(email_method)
          case email_method
          when String, Symbol, nil
            @email_method = email_method
          else
            raise ArgumentError, 'Please provide a String/Symbol value or nil'
          end
        end
      end

      # Metadata related
      begin
        # @!attribute [r] max_length
        # To configure max number of characters to truncate for each text field on index page.
        # @example To update the email method in `Admin::ApplicationController`
        #   class Admin::ApplicationController < Wallaby::ResourcesController
        #     self.max_length = 50
        #   end
        # @return [Integer] max number of characters to truncate, default to 20
        # @see Wallaby::DEFAULT_MAX
        # @since 0.2.3
        def max_length
          @max_length ||= superclass.try(:max_length) || DEFAULT_MAX
        end

        # @!attribute [w] max_length
        def max_length=(max_length)
          case max_length
          when Integer, nil
            @max_length = max_length
          else
            raise ArgumentError, 'Please provide a String/Symbol value or nil'
          end
        end
      end

      # Pagination related
      begin
        # @!attribute [r] page_size
        # To configure the page size for pagination on index page.
        #
        # Page size can be one of the following values:
        #
        # - 10
        # - 20
        # - 50
        # - 100
        # @example To update the email method in `Admin::ApplicationController`
        #   class Admin::ApplicationController < Wallaby::ResourcesController
        #     self.page_size = 50
        #   end
        # @return [Integer] page size, default to 20
        # @see Wallaby::PERS
        # @see Wallaby::DEFAULT_PAGE_SIZE
        # @since 0.2.3
        def page_size
          @page_size ||= superclass.try(:page_size) || DEFAULT_PAGE_SIZE
        end

        # @!attribute [w] page_size
        def page_size=(page_size)
          case page_size
          when Integer, nil
            @page_size = page_size
          else
            raise ArgumentError, 'Please provide a String/Symbol value or nil'
          end
        end
      end

      # Sorting related
      begin
        # @!attribute [r] sorting_strategy
        # To configure which strategy to use for sorting on index page. Options are
        #
        #   - `:multiple`: support multiple columns sorting
        #   - `:single`: support single column sorting
        # @example To update the email method in `Admin::ApplicationController`
        #   class Admin::ApplicationController < Wallaby::ResourcesController
        #     self.sorting_strategy = :single
        #   end
        # @return [Integer] sorting strategy, default to `:multiple`
        # @see Wallaby::PERS
        # @since 0.2.3
        def sorting_strategy
          @sorting_strategy ||= superclass.try(:sorting_strategy) || :multiple
        end

        # @!attribute [w] sorting_strategy
        def sorting_strategy=(sorting_strategy)
          case sorting_strategy
          when :multiple, :single, nil
            @sorting_strategy = sorting_strategy
          else
            raise ArgumentError, 'Please provide a value of `:multiple`, `:single` or nil'
          end
        end
      end
    end

    def configs
      RequestStore.store[:configs] ||= self.class
    end
    alias set_configs configs
  end
end
