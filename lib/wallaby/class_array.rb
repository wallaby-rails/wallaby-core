# frozen_string_literal: true

module Wallaby
  # This is a constant-safe array that stores Class value as String.
  class ClassArray
    include Classifier

    # @param [Array] array
    def initialize(array = [])
      @internal = array || []
      return if @internal.blank?

      @internal.map!(&method(:to_class_name))
    end

    # @!attribute [r] internal
    # @return [Array] The array to store Class values as String.
    attr_reader :internal

    # @!attribute [r] origin
    # @return [Array] The original array.
    def origin
      # NOTE: DO NOT cache it by using instance variable!
      @internal.map(&method(:to_class))
    end

    # @!method each_with_object(object)
    delegate :each_with_object, to: :origin

    # @!method ==(other)
    # Compare #{origin} with other.
    delegate :==, to: :origin

    # @!method blank?
    delegate :blank?, to: :origin
  end
end
