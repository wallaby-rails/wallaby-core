# frozen_string_literal: true

module Wallaby
  # Configurable related class methods
  module Configurable
    extend ActiveSupport::Concern

    # Engine configurables
    module ClassMethods
      # @!attribute [w] engine_name
      attr_writer :engine_name

      # @!attribute [r] engine_name
      # The engine name will be used to handle URLs.
      #
      # So when to set this engine name? When Wallaby doesn't know what is the correct engine helper to use.
      # @example To set an engine name:
      #   class Admin::ApplicationController < Wallaby::ResourcesController
      #     self.engine_name = 'admin_engine'
      #   end
      # @return [String, Symbol, nil] engine name
      # @since wallaby-5.2.0
      def engine_name
        @engine_name || superclass.try(:engine_name)
      end
    end

    # Decorator configurables
    module ClassMethods
      # @!attribute [w] resource_decorator
      def resource_decorator=(resource_decorator)
        validates_sub_class resource_decorator, application_decorator
        @resource_decorator = resource_decorator
      end

      # @!attribute [r] resource_decorator
      # Resource decorator will be used for its metadata info and decoration methods.
      #
      # If Wallaby doesn't get it right, please specify the **resource_decorator**.
      # @example To set resource decorator
      #   class Admin::ProductionsController < Admin::ApplicationController
      #     self.resource_decorator = ProductDecorator
      #   end
      # @return [Class] resource decorator
      # @raise [ArgumentError] when **resource_decorator** doesn't inherit from **application_decorator**
      # @see Wallaby::ResourceDecorator
      # @since wallaby-5.2.0
      attr_reader :resource_decorator

      # @!attribute [w] application_decorator
      def application_decorator=(application_decorator)
        validates_super_class application_decorator, resource_decorator
        @application_decorator = application_decorator
      end

      # @!attribute [r] application_decorator
      # The **application_decorator** is as the base class of {#resource_decorator}.
      # @example To set application decorator:
      #   class Admin::ApplicationController < Wallaby::ResourcesController
      #     self.application_decorator = AnotherApplicationDecorator
      #   end
      # @raise [ArgumentError] when **resource_decorator** doesn't inherit from **application_decorator**
      # @return [Class] application decorator
      # @see Wallaby::ResourceDecorator
      # @since wallaby-5.2.0
      def application_decorator
        # Make sure it always returns a application Class
        if top_reached?
          return @application_decorator ||= Guesser.class_for(
            name, suffix: DECORATOR, super_class: ResourceDecorator, &:base_class?
          ) || ResourceDecorator
        end

        @application_decorator || superclass.try(:application_decorator)
      end
    end

    # Servicer configurables
    module ClassMethods
      # @!attribute [w] model_servicer
      def model_servicer=(model_servicer)
        ModuleUtils.inheritance_check model_servicer, application_servicer
        @model_servicer = model_servicer
      end

      # @!attribute [r] model_servicer
      # If Wallaby doesn't get it right, please specify the **model_servicer**.
      # @example To set model servicer
      #   class Admin::ProductionsController < Admin::ApplicationController
      #     self.model_servicer = ProductServicer
      #   end
      # @return [Class] model servicer
      # @raise [ArgumentError] when **model_servicer** doesn't inherit from **application_servicer**
      # @see Wallaby::ModelServicer
      # @since wallaby-5.2.0
      attr_reader :model_servicer

      # @!attribute [w] application_servicer
      def application_servicer=(application_servicer)
        ModuleUtils.inheritance_check model_servicer, application_servicer
        @application_servicer = application_servicer
      end

      # @!attribute [r] application_servicer
      # The **application_servicer** is as the base class of {#model_servicer}.
      # @example To set application decorator:
      #   class Admin::ApplicationController < Wallaby::ResourcesController
      #     self.application_servicer = AnotherApplicationServicer
      #   end
      # @return [Class] application decorator
      # @raise [ArgumentError] when **model_servicer** doesn't inherit from **application_servicer**
      # @see Wallaby::ModelServicer
      # @since wallaby-5.2.0
      def application_servicer
        @application_servicer || superclass.try(:application_servicer)
      end
    end

    # Authorizer configurables
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
        @application_authorizer || superclass.try(:application_authorizer)
      end
    end

    # Paginator configurables
    module ClassMethods
      # @!attribute [w] model_paginator
      def model_paginator=(model_paginator)
        ModuleUtils.inheritance_check model_paginator, application_paginator
        @model_paginator = model_paginator
      end

      # @!attribute [r] model_paginator
      # If Wallaby doesn't get it right, please specify the **model_paginator**.
      # @example To set model paginator
      #   class Admin::ProductionsController < Admin::ApplicationController
      #     self.model_paginator = ProductPaginator
      #   end
      # @return [Class] model paginator
      # @raise [ArgumentError] when **model_paginator** doesn't inherit from **application_paginator**
      # @see Wallaby::ModelPaginator
      # @since wallaby-5.2.0
      attr_reader :model_paginator

      # @!attribute [w] application_paginator
      def application_paginator=(application_paginator)
        ModuleUtils.inheritance_check model_paginator, application_paginator
        @application_paginator = application_paginator
      end

      # @!attribute [r] application_paginator
      # The **application_paginator** is as the base class of {#model_paginator}.
      # @example To set application decorator:
      #   class Admin::ApplicationController < Wallaby::ResourcesController
      #     self.application_paginator = AnotherApplicationPaginator
      #   end
      # @return [Class] application decorator
      # @raise [ArgumentError] when **model_paginator** doesn't inherit from **application_paginator**
      # @see Wallaby::ModelPaginator
      # @since wallaby-5.2.0
      def application_paginator
        @application_paginator || superclass.try(:application_paginator)
      end
    end

    # Models configurables
    module ClassMethods
      # @!attribute [r] models
      # To configure the models that the controller should be handling.
      # It takes both Class and Class String.
      # @example To update the models in `Admin::ApplicationController`
      #   class Admin::ApplicationController < Wallaby::ResourcesController
      #     self.models = User, 'Product'
      #   end
      # @since 0.2.3
      def models
        @models || superclass.try(:models) || ClassArray.new
      end

      # @!attribute [w] models
      def models=(*models)
        @models = ClassArray.new models.flatten
      end

      # @note If models are whitelisted using {#models}, models exclusion will NOT be applied.
      # @!attribute [r] models_to_exclude
      # To configure the models to exclude that the controller should be handling.
      # It takes both Class and Class String.
      # @example To update the models to exclude in `Admin::ApplicationController`
      #   class Admin::ApplicationController < Wallaby::ResourcesController
      #     self.models_to_exclude = User, 'Product'
      #   end
      # @since 0.2.3
      def models_to_exclude
        @models_to_exclude ||
          superclass.try(:models_to_exclude) ||
          ClassArray.new(['ActiveRecord::SchemaMigration'])
      end

      # @!attribute [w] models_to_exclude
      def models_to_exclude=(*models_to_exclude)
        @models_to_exclude = ClassArray.new models_to_exclude.flatten
      end
    end

    # Authentication configurables
    module ClassMethods
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
        @logout_path || superclass.try(:logout_path)
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
        @logout_method || superclass.try(:logout_method)
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
        @email_method || superclass.try(:email_method)
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

    # Metadata configurables
    module ClassMethods
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
        @max_length || superclass.try(:max_length) || DEFAULT_MAX
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

    # Pagination configurables
    module ClassMethods
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
        @page_size || superclass.try(:page_size) || DEFAULT_PAGE_SIZE
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

    # Sorting configurables
    module ClassMethods
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
        @sorting_strategy || superclass.try(:sorting_strategy) || :multiple
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

    # Clear configurables
    module ClassMethods
      # Clear all configurations
      def clear
        %w(
          @models @models_to_exclude
          @logout_path @logout_method @email_method
          @max_length @page_size @sorting_strategy
        ).each { |name| instance_variable_set name, nil }
      end

      # Validate and see if the klass is valid subclass
      def validates_sub_class(klass, super_class)
        raise ArgumentError, 'Please provide a Class.' unless klass.is_a? Class
        return if !super_class || klass < super_class

        raise ArgumentError, "Please provide a Class that inherits from #{super_class}."
      end

      # Validate and see if the klass is valid superclass
      def validates_super_class(klass, sub_class)
        raise ArgumentError, 'Please provide a Class.' unless klass.is_a? Class
        return if !sub_class || sub_class < klass

        raise ArgumentError, "Please provide a Class that is a superclass of #{sub_class}."
      end

      # Reaching the top of class inheritance chain for Classes that includes {Wallaby::Configurable}?
      def top_reached?
        superclass == ResourcesController || !(superclass < Configurable)
      end
    end

    protected

    # Store controller class for later #{Wallaby.controller} usage.
    def set_controller_class
      RequestStore.store[:wallaby_controller] ||= self.class
    end
  end
end
