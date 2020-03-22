# frozen_string_literal: true

module Wallaby
  # Locale related
  module Locale
    # Extend translation just for Wallaby
    # so that translation can be prefixed with `wallaby.`
    # @param key
    # @param options [Hash] the rest of the arguments
    # @return [String] translation
    def self.t(key, options = {})
      translator = options.delete(:translator) || I18n.method(:t)
      return translator.call(key, options) unless key.is_a?(String) || key.is_a?(Symbol)

      defaults = options.delete(:default)
      if defaults.is_a? Array
        *keys, default = *defaults
      else
        keys, default = [], defaults
      end

      unless default.nil? || default.is_a?(String)
        keys << default
        default = nil
      end

      new_keys = keys.unshift(key).each_with_object([]) do |k, result|
        result << :"wallaby.#{k}" unless k.to_s.start_with? 'wallaby.'
        result << k.to_sym
      end
      new_key = new_keys.shift
      new_keys << default if default

      translator.call(new_key, {default: new_keys}.merge(options))
      # .find do |k|
      #   translation = translator.call(k, {default: EMPTY_STRING}.merge(options))
      #   return translation if translation.present?
      # end || default
      # new_key = new_keys.shift
      # new_defaults = new_keys.

      # keys = Array(options.delete(:default)).unshift(key)
      # translator.call(
      #   :"wallaby.#{key}", { default: EMPTY_STRING }.merge(options)
      # ).presence || translator.call(
      #   key, {default: default}.merge(options)
      # )
    end
  end
end
