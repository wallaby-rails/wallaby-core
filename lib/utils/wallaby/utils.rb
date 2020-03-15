# frozen_string_literal: true

module Wallaby
  # Utils
  module Utils
    # Display deprecate message including the line where it's used
    # @param key [String]
    # @param caller [String] the line where it's called
    # @param options [Hash]
    def self.deprecate(key, caller:, options: {})
      warn Utils.t(key, options.merge(from: caller[0]))
    end

    # @see http://stackoverflow.com/a/8710663/1326499
    # @param object [Object]
    # @return [Object] a clone object
    def self.clone(object)
      ::Marshal.load(::Marshal.dump(object))
    end

    # Extend translation just for Wallaby
    # so that translation can be prefixed with `wallaby.`
    # @param key
    # @param options [Array] the rest of the arguments
    # @return [String] translation
    def self.t(key, **options)
      translator = options.delete(:translator) || I18n.method(:t)
      return translator.call(key, **options) unless key.is_a?(String) || key.is_a?(Symbol)

      translator.call(
        :"wallaby.#{key}",
        **{ default: [key.to_sym, key.to_s.humanize] }.merge(options)
      )
    end
  end
end
