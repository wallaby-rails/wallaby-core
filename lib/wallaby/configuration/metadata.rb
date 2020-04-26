# frozen_string_literal: true

module Wallaby
  class Configuration
    # Metadata configuration
    class Metadata
      # @!attribute [w] max
      def max=(max)
        Deprecator.alert 'config.metadata.max=', from: '0.3', alternative: <<~INSTRUCTION
          Please use set #max_length= from the controller instead, for example:

            class Admin::ApplicationController < Wallaby::ResourcesController
              self.max_length = 50
            end
        INSTRUCTION
        @max = max
      end

      # @!attribute [r] resources_controller
      # To globally configure max number of characters to truncate.
      # @example To update max number of characters to truncate to 50 in `config/initializers/wallaby.rb`
      #   Wallaby.config do |config|
      #     config.metadata.max = 50
      #   end
      # @return [Integer] max number of characters to truncate, default to 20
      # @since wallaby-5.1.6
      def max
        @max ||= DEFAULT_MAX
      end
    end
  end
end
