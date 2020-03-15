# frozen_string_literal: true

module Wallaby
  # Utils
  module Utils
    # Display deprecate message including the line where it's used
    # @param key [String]
    # @param caller [String] the line where it's called
    # @param options [Hash]
    def self.deprecate(key, caller:, options: {})
      warn Wallaby.t(key, options.merge(from: caller[0]))
    end

    # @see http://stackoverflow.com/a/8710663/1326499
    # @param object [Object]
    # @return [Object] a clone object
    def self.clone(object)
      ::Marshal.load(::Marshal.dump(object))
    end
  end
end
