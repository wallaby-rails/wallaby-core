# frozen_string_literal: true

module Wallaby
  # This is a constant-safe array that stores Class value as String.
  class ClassArray
    include Classifier

    # @param [Array] array
    def initialize(*array)
      @internal = (array || []).flatten
      return if @internal.blank?

      @internal.map!(&method(:class_name_of)).compact!
    end

    # @!attribute [r] internal
    # @return [Array] The array to store Class values as String.
    attr_reader :internal

    # @!attribute [r] origin
    # @return [Array] The original array.
    def origin
      # NOTE: DO NOT cache it by using instance variable!
      @internal.map(&method(:to_class)).compact
    end

    # Save the value to the {#internal} array at the given index, and convert the Class value to String
    def []=(index, value)
      @internal[index] = class_name_of value
    end

    # Return the value for the given index
    def [](index)
      to_class @internal[index]
    end

    # @param other [Array]
    # @return [Wallaby::ClassArray] new Class array
    def concat(other)
      self.class.new origin.concat(other.try(:origin) || other)
    end

    # @param other [Array]
    # @return [Wallaby::ClassArray] new Class array
    def -(other)
      self.class.new origin - (other.try(:origin) || other)
    end

    # @return [Wallaby::ClassArray] self
    def each(&block)
      origin.each(&block)
      self
    end

    # @!method ==(other)
    # Compare #{origin} with other.
    delegate :==, to: :origin

    # @!method blank?
    delegate :blank?, to: :internal

    # @!method each_with_object(object)
    delegate :each_with_object, to: :origin

    # @!method to_sentence
    delegate :to_sentence, to: :origin

    # Ensure to freeze the {#internal}
    # @return [Wallaby::ClassArray] self
    def freeze
      @internal.freeze
      super
    end
  end
end
