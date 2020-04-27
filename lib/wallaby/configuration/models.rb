# frozen_string_literal: true

module Wallaby
  class Configuration
    # @deprecated will move this configuration to {Wallaby::ResourcesController} from 0.3
    # Models configuration to specify the model classes that Wallaby should handle.
    class Models
      # @deprecated
      # @note If models are whitelisted, models exclusion will NOT be applied.
      # To globally configure what model classes that Wallaby should handle.
      # @example To whitelist the model classes in `config/initializers/wallaby.rb`
      #   Wallaby.config do |config|
      #     config.models = [Product, Order]
      #   end
      # @param models [Array<Class, String>]
      def set(*models)
        Deprecator.alert 'config.models=', from: '0.3', alternative: <<~INSTRUCTION
          Please use #models= from the controller instead, for example:

            class Admin::ApplicationController < Wallaby::ResourcesController
              self.models = User, 'Product'
            end
        INSTRUCTION

        Wallaby.configuration.resources_controller.models = models.flatten
        Wallaby.configuration.resources_controller.models
      end

      # @deprecated
      # @return [Array<Class>] the models configured
      def presence
        Wallaby.configuration.resources_controller.models
      end

      # @deprecated
      # @note If models are whitelisted using {#set}, models exclusion will NOT be applied.
      # To globally configure what model classes to exclude.
      # @example To exclude models in `config/initializers/wallaby.rb`
      #   Wallaby.config do |config|
      #     config.models.exclude Product, Order
      #   end
      # @param models [Array<Class, String>]
      def exclude(*models)
        Deprecator.alert 'config.models.exclude', from: '0.3', alternative: <<~INSTRUCTION
          Please use #models_to_exclude from the controller instead, for example:

            class Admin::ApplicationController < Wallaby::ResourcesController
              self.models_to_exclude User, 'Product'
            end
        INSTRUCTION

        Wallaby.configuration.resources_controller.models_to_exclude = models
        Wallaby.configuration.resources_controller.models_to_exclude
      end

      # @deprecated
      # @return [Array<Class>] the list of models to exclude.
      #   By default, `ActiveRecord::SchemaMigration` is excluded.
      def excludes
        Wallaby.configuration.resources_controller.models_to_exclude
      end
    end
  end
end
