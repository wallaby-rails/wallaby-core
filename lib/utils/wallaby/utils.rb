# frozen_string_literal: true

module Wallaby
  # Utils
  module Utils
    # @see http://stackoverflow.com/a/8710663/1326499
    # @param object [Object]
    # @return [Object] a clone object
    def self.clone(object)
      ::Marshal.load(::Marshal.dump(object))
    end

    # @param object [Object, nil]
    # @return [String] inspection string for the given object
    def self.inspect(object)
      return 'nil' unless object
      return object.name if object.is_a? Class

      "#{object.class}##{object.try(:id)}"
    end
  end
end
