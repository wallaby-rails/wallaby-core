# frozen_string_literal: true

# Just for translation
module Wallaby
  # Extend translation just for Wallaby
  # so that translation can be prefixed with `wallaby.`
  # @param key
  # @param options [Array] the rest of the arguments
  # @return [String] translation
  def self.t(key, **options)
    translater = options.delete(:translater) || I18n.method(:t)
    return translater.call(key, **options) unless key.is_a?(String) || key.is_a?(Symbol)

    translater.call(
      :"wallaby.#{key}",
      **options.with_defaults(default: [key.to_sym, key.to_s.humanize])
    )
  end
end
