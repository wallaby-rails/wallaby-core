# frozen_string_literal: true

module Wallaby
  class Configuration
    # @deprecated
    # Sorting global configuration
    # @since wallaby-5.2.0
    class Sorting
      # @deprecated
      # @!attribute [w] strategy
      def strategy=(_strategy)
        Deprecator.alert 'config.sorting.strategy=', from: '0.2.2', alternative: <<~INSTRUCTION
          Please set #sorting_strategy= from the controller instead, for example:

            class Admin::ApplicationController < Wallaby::ResourcesController
              self.sorting_strategy = :multiple
            end
        INSTRUCTION
      end

      # @deprecated
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
        Deprecator.alert 'config.sorting.strategy', from: '0.2.2', alternative: <<~INSTRUCTION
          Please use controller_class.sorting_strategy instead.
        INSTRUCTION
      end
    end
  end
end
