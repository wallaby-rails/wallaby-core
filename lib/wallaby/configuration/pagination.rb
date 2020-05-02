# frozen_string_literal: true

module Wallaby
  class Configuration
    # @deprecated
    # Pagination configuration
    class Pagination
      # @deprecated
      # @!attribute [w] page_size
      def page_size=(page_size)
        Deprecator.alert 'config.pagination.page_size=', from: '0.2.2', alternative: <<~INSTRUCTION
          Please set #page_size= from the controller instead, for example:

            class Admin::ApplicationController < Wallaby::ResourcesController
              self.page_size = 50
            end
        INSTRUCTION

        Wallaby.configuration.resources_controller.page_size = page_size
      end

      # @deprecated
      # @!attribute [r] page_size
      # To globally configure the page size for pagination.
      #
      # Page size can be one of the following values:
      #
      # - 10
      # - 20
      # - 50
      # - 100
      # @see Wallaby::PERS
      # @example To update the page size in `config/initializers/wallaby.rb`
      #   Wallaby.config do |config|
      #     config.pagination.page_size = 50
      #   end
      # @return [Integer] page size, default to 20
      def page_size
        Deprecator.alert 'config.pagination.page_size', from: '0.2.2', alternative: <<~INSTRUCTION
          Please use controller_class.page_size instead.
        INSTRUCTION
      end
    end
  end
end
