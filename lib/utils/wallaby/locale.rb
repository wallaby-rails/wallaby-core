# frozen_string_literal: true

module Wallaby
  # Locale related
  module Locale
    class << self
      # Extend translation just for Wallaby
      # so that translation can be prefixed with `wallaby.`
      # @param key
      # @param options [Hash] the rest of the arguments
      # @return [String] translation
      def t(key, options = {})
        translator = options.delete(:translator) || I18n.method(:t)
        return translator.call(key, options) unless key.is_a?(String) || key.is_a?(Symbol)

        new_key, new_defaults = normalize key, options.delete(:default)

        translator.call(new_key, { default: new_defaults }.merge(options))
      end

      private

      def normalize(key, defaults)
        *keys, default = *defaults

        unless default.nil? || default.is_a?(String)
          keys << default
          default = nil
        end

        new_defaults = build_new_defaults_from keys.unshift(key)
        new_key = new_defaults.shift
        new_defaults << default if default
        [new_key, new_defaults]
      end

      def build_new_defaults_from(keys)
        keys.each_with_object([]) do |k, result|
          result << :"wallaby.#{k}" unless k.to_s.start_with? 'wallaby.'
          result << k.to_sym
        end
      end
    end
  end
end
