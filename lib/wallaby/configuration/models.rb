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
      def set(*_models)
        Deprecator.alert 'config.models.set', from: '0.2.2', alternative: <<~INSTRUCTION
          Please set #models= from the controller instead, for example:

            class Admin::ApplicationController < Wallaby::ResourcesController
              self.models = User, 'Product'
            end
        INSTRUCTION
      end

      # @deprecated
      # @return [Array<Class>] the models configured
      def presence
        Deprecator.alert 'config.models.presence', from: '0.2.2', alternative: <<~INSTRUCTION
          Please use controller_class.models instead.
        INSTRUCTION
      end

      # @deprecated
      # @note If models are whitelisted using {#set}, models exclusion will NOT be applied.
      # To globally configure what model classes to exclude.
      # @example To exclude models in `config/initializers/wallaby.rb`
      #   Wallaby.config do |config|
      #     config.models.exclude Product, Order
      #   end
      # @param models [Array<Class, String>]
      def exclude(*_models)
        Deprecator.alert 'config.models.exclude', from: '0.2.2', alternative: <<~INSTRUCTION
          Please set #models_to_exclude from the controller instead, for example:

            class Admin::ApplicationController < Wallaby::ResourcesController
              self.models_to_exclude User, 'Product'
            end
        INSTRUCTION
      end

      # @deprecated
      # @return [Array<Class>] the list of models to exclude.
      #   By default, `ActiveRecord::SchemaMigration` is excluded.
      def excludes
        Deprecator.alert 'config.models.excludes', from: '0.2.2', alternative: <<~INSTRUCTION
          Please use controller_class.models_to_exclude instead.
        INSTRUCTION
      end
    end
  end
end
