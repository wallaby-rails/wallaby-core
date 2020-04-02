# frozen_string_literal: true

module Wallaby
  # This is a type of array that handles Class keys and values differently.
  # It stores Class key/value as String and returns String value as Class.
  class ClassArray
    include Classifier

    attr_reader :internal
    delegate :==, :blank?, to: :internal

    def initialize(array = [])
      @internal = array || []
      return if @internal.blank?

      @internal.map!(&as_class_name)
    end

    # # @param index [Integer]
    # # @param klass_value [Class, String]
    # def []=(index, klass_value)
    #   @internal[index] = to_class_name(klass_value)
    # end

    # # @param index [Integer]
    # # @return [Class] Class value
    # def [](index)
    #   to_class @internal[index]
    # end

    # @param object [Object]
    # @return [Object]
    def each_with_object(object)
      @internal.each_with_object(object) do |item, memo|
        yield to_class(item), memo
      end
    end

    # # @param other [Array]
    # # @return [Wallaby::ClassArray] new Class array
    # def concat(other)
    #   self.class.new @internal.concat(other)
    # end
  end
end
