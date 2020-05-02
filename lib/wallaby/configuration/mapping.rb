# frozen_string_literal: true

module Wallaby
  class Configuration
    # @deprecated
    # Configuration used in {Wallaby::Map}
    # @since wallaby-5.1.6
    class Mapping
      include Classifier

      # @deprecated
      # @!attribute [w] resources_controller
      def resources_controller=(_resources_controller)
        Deprecator.alert 'config.mapping.resources_controller=', from: '0.2.2', alternative: <<~INSTRUCTION
          Please set #resources_controller= from the config instead, for example:

            Wallaby.config do |config|
              config.resources_controller = ::GlobalResourcesController
            end
        INSTRUCTION
      end

      # @deprecated
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
        Deprecator.alert 'config.mapping.resources_controller', from: '0.2.2', alternative: <<~INSTRUCTION
          Please use config.resources_controller instead.
        INSTRUCTION
      end

      # @deprecated
      # @!attribute [w] resource_decorator
      def resource_decorator=(_resource_decorator)
        Deprecator.alert 'config.mapping.resource_decorator=', from: '0.2.2', alternative: <<~INSTRUCTION
          Please set .application_decorator= from the controller instead, for example:

            class Admin::ApplicationController < Wallaby::ResourcesController
              self.application_decorator = ::GlobalModelDecorator
            end
        INSTRUCTION
      end

      # @deprecated
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
        Deprecator.alert 'config.mapping.resource_decorator', from: '0.2.2', alternative: <<~INSTRUCTION
          Please use controller_class.application_decorator.
        INSTRUCTION
      end

      # @deprecated
      # @!attribute [w] model_servicer
      def model_servicer=(_model_servicer)
        Deprecator.alert 'config.mapping.model_servicer=', from: '0.2.2', alternative: <<~INSTRUCTION
          Please set .application_servicer= from the controller instead, for example:

            class Admin::ApplicationController < Wallaby::ResourcesController
              self.application_servicer = ::GlobalModelServicer
            end
        INSTRUCTION
      end

      # @deprecated
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
        Deprecator.alert 'config.mapping.model_servicer', from: '0.2.2', alternative: <<~INSTRUCTION
          Please use controller_class.application_servicer.
        INSTRUCTION
      end

      # @deprecated
      # @!attribute [w] model_authorizer
      def model_authorizer=(_model_authorizer)
        Deprecator.alert 'config.mapping.model_authorizer=', from: '0.2.2', alternative: <<~INSTRUCTION
          Please set .application_authorizer= from the controller instead, for example:

            class Admin::ApplicationController < Wallaby::ResourcesController
              self.application_authorizer = ::GlobalModelAuthorizer
            end
        INSTRUCTION
      end

      # @deprecated
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
        Deprecator.alert 'config.mapping.model_authorizer', from: '0.2.2', alternative: <<~INSTRUCTION
          Please use controller_class.application_authorizer.
        INSTRUCTION
      end

      # @deprecated
      # @!attribute [w] model_paginator
      def model_paginator=(_model_paginator)
        Deprecator.alert 'config.mapping.model_paginator=', from: '0.2.2', alternative: <<~INSTRUCTION
          Please set .application_paginator= from the controller instead, for example:

            class Admin::ApplicationController < Wallaby::ResourcesController
              self.application_paginator = ::GlobalModelPaginator
            end
        INSTRUCTION
      end

      # @deprecated
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
        Deprecator.alert 'config.mapping.model_paginator', from: '0.2.2', alternative: <<~INSTRUCTION
          Please use controller_class.application_paginator.
        INSTRUCTION
      end
    end
  end
end
