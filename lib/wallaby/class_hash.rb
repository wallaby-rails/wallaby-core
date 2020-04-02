# frozen_string_literal: true

module Wallaby
  # This is a type of hash that handles Class keys and values differently.
  # It stores Class key/value as String and returns String value as Class.
  class ClassHash
    include Classifier

    attr_reader :internal
    delegate :==, to: :internal

    def initialize(hash = {})
      @internal = hash || {}
      return if @internal.blank?

      @internal.transform_keys!(&as_class_name).transform_values!(&as_class_name)
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
      self.class.new @internal.merge(other)
    end

    def freeze
      @internal.freeze
      super
    end
  end
end
