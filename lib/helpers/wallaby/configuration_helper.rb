# frozen_string_literal: true

module Wallaby
  # Configuration helper module. Provide shortcut methods to configurations.
  module ConfigurationHelper
    delegate :controller_configuration, to: Wallaby
    delegate :max_text_length, to: :controller_configuration

    # @return [Wallaby::Configuration] shortcut method of configuration
    def configuration
      Wallaby.configuration
    end

    # @return [Wallaby::Configuration::Metadata] shortcut method of metadata
    def default_metadata
      Deprecator.alert 'default_metadata.max', from: '0.3.0', alternative: <<~INSTRUCTION
        Please use `max_text_length` instead
      INSTRUCTION
    end

    def mapping
      Deprecator.alert method(__callee__), from: '0.3.0'
    end

    def security
      Deprecator.alert method(__callee__), from: '0.3.0'
    end

    def models
      Deprecator.alert method(__callee__), from: '0.3.0'
    end

    def pagination
      Deprecator.alert method(__callee__), from: '0.3.0'
    end

    def features
      Deprecator.alert method(__callee__), from: '0.3.0'
    end

    def sorting
      Deprecator.alert method(__callee__), from: '0.3.0'
    end
  end
end
