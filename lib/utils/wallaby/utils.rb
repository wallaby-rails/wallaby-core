# frozen_string_literal: true

module Wallaby
  # Utils
  module Utils
    # @see http://stackoverflow.com/a/8710663/1326499
    # @param object [Object]
    # @return [Object] a clone object
    def self.clone(object)
      # NOTE: Neither marshal/deep_dup/dup are able to achieve real and correct deep copy,
      # so here we need a custom solution below:
      case object
      when Hash
        object
          .each_with_object(object.class.new) { |(key, value), hash| hash[key] = clone(value) }
          .tap { |hash| hash.default = object.default }
      when Array
        object.each_with_object(object.class.new) { |value, array| array << clone(value) }
      when Class
        # NOTE: `Class.dup` will turn the duplicate class into anonymous class
        # therefore, we just return the Class itself here
        object
      else
        object.dup
      end
    end

    # @param object [Object, nil]
    # @return [String] inspection string for the given object
    def self.inspect(object)
      return 'nil' unless object
      return object.name if object.is_a? Class

      "#{object.class}##{object.id}"
    end
  end
end
