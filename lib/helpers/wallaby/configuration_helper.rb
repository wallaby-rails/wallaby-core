# frozen_string_literal: true

module Wallaby
  # Configuration helper module. Provide shortcut methods to configurations.
  module ConfigurationHelper
    delegate :controller_configuration, to: Wallaby
    delegate :models, :security, :mapping, :pagination, :features, :sorting, to: :configuration

    # @return [Wallaby::Configuration] shortcut method of configuration
    def configuration
      Wallaby.configuration
    end

    # @return [Wallaby::Configuration::Metadata] shortcut method of metadata
    def default_metadata
      Deprecator.alert 'default_metadata.max', from: '0.3', alternative: <<~INSTRUCTION
        Please use `max_text_length` instead
      INSTRUCTION
    end

    def max_text_length
      controller_configuration.max_length
    end
  end
end
