# frozen_string_literal: true

module Wallaby
  class Configuration
    # @deprecated
    # Metadata configuration
    class Metadata
      # @deprecated
      # @!attribute [w] max
      def max=(_max)
        Deprecator.alert 'config.metadata.max=', from: '0.3', alternative: <<~INSTRUCTION
          Please set .max_length= from the controller instead, for example:

            class Admin::ApplicationController < Wallaby::ResourcesController
              self.max_length = 50
            end
        INSTRUCTION
      end

      # @deprecated
      # @!attribute [r] max
      def max
        Deprecator.alert 'config.metadata.max', from: '0.3', alternative: <<~INSTRUCTION
          Please use controller_class.max_length instead.
        INSTRUCTION
      end
    end
  end
end
