# frozen_string_literal: true

module Wallaby
  class Configuration
    # Metadata configuration
    class Metadata
      # @!attribute [w] max
      def max=(_max)
        Deprecator.alert 'config.metadata.max=', from: '0.3', alternative: <<~INSTRUCTION
          Please use set #max_length= from the controller instead, for example:

            class Admin::ApplicationController < Wallaby::ResourcesController
              self.max_length = 50
            end
        INSTRUCTION
      end
    end
  end
end
