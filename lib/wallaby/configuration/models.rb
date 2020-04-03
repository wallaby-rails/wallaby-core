# frozen_string_literal: true

module Wallaby
  class Configuration
    # @deprecated will move this configuration to {Wallaby::ResourcesController} from 6.2
    # Models configuration to specify the model classes that Wallaby should handle.
    class Models
      include Classifier
      # @note If models are whitelisted, models exclusion will NOT be applied.
      # To globally configure what model classes that Wallaby should handle.
      # @example To whitelist the model classes in `config/initializers/wallaby.rb`
      #   Wallaby.config do |config|
      #     config.models = [Product, Order]
      #   end
      # @param models [Array<Class, String>]
      def set(*models)
        @models = Array(models).flatten.map(&method(:to_class_name)).compact
      end

      # @return [Array<Class>] the models configured
      def presence
        (@models ||= []).map(&method(:to_class))
      end

      # @note If models are whitelisted using {#set}, models exclusion will NOT be applied.
      # To globally configure what model classes to exclude.
      # @example To exclude models in `config/initializers/wallaby.rb`
      #   Wallaby.config do |config|
      #     config.models.exclude Product, Order
      #   end
      # @param models [Array<Class, String>]
      def exclude(*models)
        @excludes = Array(models).flatten.map(&method(:to_class_name)).compact
      end

      # @return [Array<Class>] the list of models to exclude.
      #   By default, `ActiveRecord::SchemaMigration` is excluded.
      def excludes
        (@excludes ||= ['ActiveRecord::SchemaMigration']).map(&method(:to_class))
      end
    end
  end
end
