# frozen_string_literal: true

module Wallaby
  class Configuration
    # Configuration used in {Wallaby::Map}
    # @since wallaby-5.1.6
    class Mapping
      include Classifier

      # @!attribute [w] resources_controller
      def resources_controller=(resources_controller)
        @resources_controller = to_class_name resources_controller
      end

      # @!attribute [r] resources_controller
      # To globally configure the resources controller.
      #
      # If no configuration is given, Wallaby will look up from the following controller classes
      # and use the first available one:
      #
      # - ::Admin::ApplicationController (only when it inherits from {Wallaby::ResourcesController})
      # - {Wallaby::ResourcesController}
      # @example To update the resources controller to `GlobalResourcesController` in `config/initializers/wallaby.rb`
      #   Wallaby.config do |config|
      #     config.mapping.resources_controller = ::GlobalResourcesController
      #   end
      # @return [Class] resources controller class
      # @since wallaby-5.1.6
      def resources_controller
        @resources_controller ||=
          defined?(::Admin::ApplicationController) \
            && ::Admin::ApplicationController < ::Wallaby::ResourcesController \
            && 'Admin::ApplicationController'
        to_class @resources_controller ||= 'Wallaby::ResourcesController'
      end

      # @!attribute [w] resource_decorator
      def resource_decorator=(resource_decorator)
        @resource_decorator = to_class_name resource_decorator
      end

      # @!attribute [r] resource_decorator
      # To globally configure the resource decorator.
      #
      # If no configuration is given, Wallaby will look up from the following decorator classes
      # and use the first available one:
      #
      # - ::Admin::ApplicationDecorator (only when it inherits from {Wallaby::ResourceDecorator})
      # - {Wallaby::ResourceDecorator}
      # @example To update the resource decorator to `GlobalResourceDecorator` in `config/initializers/wallaby.rb`
      #   Wallaby.config do |config|
      #     config.mapping.resource_decorator = ::GlobalResourceDecorator
      #   end
      # @return [Class] resource decorator class
      # @since wallaby-5.1.6
      def resource_decorator
        @resource_decorator ||=
          defined?(::Admin::ApplicationDecorator) \
            && ::Admin::ApplicationDecorator < ::Wallaby::ResourceDecorator \
            && 'Admin::ApplicationDecorator'
        to_class @resource_decorator ||= 'Wallaby::ResourceDecorator'
      end

      # @!attribute [w] model_servicer
      def model_servicer=(model_servicer)
        @model_servicer = to_class_name model_servicer
      end

      # @!attribute [r] model_servicer
      # To globally configure the model servicer.
      #
      # If no configuration is given, Wallaby will look up from the following servicer classes
      # and use the first available one:
      #
      # - ::Admin::ApplicationServicer (only when it inherits from {Wallaby::ModelServicer})
      # - {Wallaby::ModelServicer}
      # @example To update the model servicer to `GlobalModelServicer` in `config/initializers/wallaby.rb`
      #   Wallaby.config do |config|
      #     config.mapping.model_servicer = ::GlobalModelServicer
      #   end
      # @return [Class] model servicer class
      # @since wallaby-5.1.6
      def model_servicer
        @model_servicer ||=
          defined?(::Admin::ApplicationServicer) \
            && ::Admin::ApplicationServicer < ::Wallaby::ModelServicer \
            && 'Admin::ApplicationServicer'
        to_class @model_servicer ||= 'Wallaby::ModelServicer'
      end

      # @!attribute [w] model_authorizer
      def model_authorizer=(model_authorizer)
        @model_authorizer = to_class_name model_authorizer
      end

      # @!attribute [r] model_authorizer
      # To globally configure the model authorizer.
      #
      # If no configuration is given, Wallaby will look up from the following authorizer classes
      # and use the first available one:
      #
      # - ::Admin::ApplicationAuthorizer (only when it inherits from {Wallaby::ModelAuthorizer})
      # - {Wallaby::ModelAuthorizer}
      # @example To update the model authorizer to `GlobalModelAuthorizer` in `config/initializers/wallaby.rb`
      #   Wallaby.config do |config|
      #     config.mapping.model_authorizer = ::GlobalModelAuthorizer
      #   end
      # @return [Class] model authorizer class
      # @since wallaby-5.2.0
      def model_authorizer
        @model_authorizer ||=
          defined?(::Admin::ApplicationAuthorizer) \
            && ::Admin::ApplicationAuthorizer < ::Wallaby::ModelAuthorizer \
            && 'Admin::ApplicationAuthorizer'
        to_class @model_authorizer ||= 'Wallaby::ModelAuthorizer'
      end

      # @!attribute [w] model_paginator
      def model_paginator=(model_paginator)
        @model_paginator = to_class_name model_paginator
      end

      # @!attribute [r] model_paginator
      # To globally configure the resource paginator.
      #
      # If no configuration is given, Wallaby will look up from the following paginator classes
      # and use the first available one:
      #
      # - ::Admin::ApplicationPaginator (only when it inherits from {Wallaby::ModelPaginator})
      # - {Wallaby::ModelPaginator}
      # @example To update the resource paginator to `GlobalModelPaginator` in `config/initializers/wallaby.rb`
      #   Wallaby.config do |config|
      #     config.mapping.model_paginator = ::GlobalModelPaginator
      #   end
      # @return [Class] resource paginator class
      # @since wallaby-5.2.0
      def model_paginator
        @model_paginator ||=
          defined?(::Admin::ApplicationPaginator) \
            && ::Admin::ApplicationPaginator < ::Wallaby::ModelPaginator \
            && 'Admin::ApplicationPaginator'
        to_class @model_paginator ||= 'Wallaby::ModelPaginator'
      end
    end
  end
end
