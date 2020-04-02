# frozen_string_literal: true

module Wallaby
  # This is a type of hash that handles Class keys and values differently.
  # It stores Class key/value as String and returns String value as Class.
  class ClassHash
    attr_reader :internal

    def initialize(hash = {})
      @internal =
        (hash || {})
        .transform_keys(&method(:to_class_name))
        .transform_values(&method(:to_class_name))
    end

    # @param klass_key [Class, String]
    # @param klass_value [Class, String]
    def []=(klass_key, klass_value)
      @internal[to_class_name(klass_key)] = to_class_name(klass_value)
    end

    # @param klass_key [Class, String]
    # @return [Class] Class value
    def [](klass_key)
      to_class @internal[to_class_name(klass_key)]
    end

    # @param other [Hash]
    # @return [Wallaby::ClassHash] new Class hash
    def merge(other)
      self.class.new @internal.merge(other.try(:internal) || other)
    end

    # Compare with other
    def ==(other)
      origin == (other.try(:origin) || other)
    end

    # @return [Wallaby::ClassHash]
    def freeze
      @internal.freeze
      super
    end

    # @return [Hash] original hash
    def origin
      @internal.transform_keys(&method(:to_class)).transform_values(&method(:to_class))
    end

    protected

    # Convert to Class name
    def to_class_name(klass)
      klass.is_a?(Class) ? [klass.name, true] : [klass, false]
    end

    # Convert to Class
    def to_class(pair)
      val, is_class = pair
      is_class ? val.constantize : val
    end
  end
end
