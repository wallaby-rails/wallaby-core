# frozen_string_literal: true

module Wallaby
  # (see #execute)
  class DefaultModelsExcluder
    class << self
      # Find decorator class by script name and model class from the following places:
      #
      # - {#controller_class}'s {Configurable::ClassMethods#resource_decorator #resource_decorator}
      # - possible decorator class built from script name and model class,
      #   e.g. **/admin** and **Order::Item** will give us the possible decorators:
      #   - Admin::Order::ItemDecorator
      #   - Order::ItemDecorator
      #   - ItemDecorator
      # - {#controller_class}'s default
      #   {Configurable::ClassMethods#application_decorator #application_decorator}
      # @return [Class] decorator class
      def execute
        ClassArray.new(
          [].tap do |list|
            list << active_record_schema_migration
            list << active_record_internal_metadata
          end.compact
        )
      end

      protected

      def active_record_schema_migration
        exist_or_not =
          # does Wallaby know ActiveRecord::SchemaMigration existence?
          defined?(::ActiveRecord::SchemaMigration) \
            && Map.mode_map.keys.include?(::ActiveRecord::SchemaMigration)

        exist_or_not ? ::ActiveRecord::SchemaMigration : nil
      end

      def active_record_internal_metadata
        exist_or_not =
          # does Wallaby know ActiveRecord::InternalMetadata existence?
          defined?(::ActiveRecord::InternalMetadata) \
            && Map.mode_map.keys.include?(::ActiveRecord::InternalMetadata)

        exist_or_not ? ::ActiveRecord::InternalMetadata : nil
      end
    end
  end
end
