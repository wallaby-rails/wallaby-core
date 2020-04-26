# frozen_string_literal: true

module Wallaby
  class Configuration
    # @deprecated will move this configuration to {Wallaby::ResourcesController} from 0.3
    # Models configuration to specify the model classes that Wallaby should handle.
    class Models
      # @note If models are whitelisted, models exclusion will NOT be applied.
      # To globally configure what model classes that Wallaby should handle.
      # @example To whitelist the model classes in `config/initializers/wallaby.rb`
      #   Wallaby.config do |config|
      #     config.models = [Product, Order]
      #   end
      # @param models [Array<Class, String>]
      def set(*models)
        @models = ClassArray.new(models.flatten)
      end

      # @return [Array<Class>] the models configured
      def presence
        @models ||= ClassArray.new # rubocop:disable Naming/MemoizedInstanceVariableName
      end

      # @note If models are whitelisted using {#set}, models exclusion will NOT be applied.
      # To globally configure what model classes to exclude.
      # @example To exclude models in `config/initializers/wallaby.rb`
      #   Wallaby.config do |config|
      #     config.models.exclude Product, Order
      #   end
      # @param models [Array<Class, String>]
      def exclude(*models)
        @excludes = ClassArray.new(models.flatten)
      end

      # @return [Array<Class>] the list of models to exclude.
      #   By default, `ActiveRecord::SchemaMigration` is excluded.
      def excludes
        @excludes ||= ClassArray.new ['ActiveRecord::SchemaMigration']
      end
    end
  end
end
