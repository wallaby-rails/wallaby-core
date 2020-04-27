# frozen_string_literal: true

module Wallaby
  class Configuration
    # Sorting global configuration
    # @since wallaby-5.2.0
    class Sorting
      # @!attribute [w] strategy
      def strategy=(strategy)
        Deprecator.alert 'config.metadata.max=', from: '0.3', alternative: <<~INSTRUCTION
          Please use set #max_length= from the controller instead, for example:

            class Admin::ApplicationController < Wallaby::ResourcesController
              self.max_length = 50
            end
        INSTRUCTION

        Wallaby.configuration.resources_controller.sorting_strategy = strategy
      end

      # @!attribute [r] strategy
      # To globally configure which strategy to use for sorting. Options are
      #
      #   - `:multiple`: support multiple columns sorting
      #   - `:single`: support single column sorting
      #
      # By default, strategy is `:multiple`.
      # @example To enable turbolinks:
      #   Wallaby.config do |config|
      #     config.sorting.strategy = :single
      #   end
      # @return [Symbol, String]
      def strategy
        Deprecator.alert 'config.metadata.max=', from: '0.3', alternative: <<~INSTRUCTION
          Please use set #max_length= from the controller instead, for example:

            class Admin::ApplicationController < Wallaby::ResourcesController
              self.max_length = 50
            end
        INSTRUCTION

        Wallaby.configuration.resources_controller.sorting_strategy
      end
    end
  end
end
