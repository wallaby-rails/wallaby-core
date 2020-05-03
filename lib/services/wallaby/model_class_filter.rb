# frozen_string_literal: true

module Wallaby
  # Fitler the model classes using
  class ModelClassFilter
    class << self
      # @param class_array [Array<Class>]
      def execute(all:, whitelisted:, blacklisted:)
        invalid, valid =
          if whitelisted.present? then [whitelisted - all, whitelisted]
          else [blacklisted - all, all - blacklisted]
          end
        return valid if invalid.blank?

        raise InvalidError, <<~INSTRUCTION
          Wallaby can't handle these models: #{invalid.map(&:name).to_sentence}.
          If it's set via controller_class.models= or controller_class.models_to_exclude=,
          please remove them from the list.

          Or they can be added to Custom model list as below, and custom implementation will be required:

            Wallaby.config do |config|
              config.custom_models = #{invalid.map(&:name).join ', '}
            end
        INSTRUCTION
      end
    end
  end
end
