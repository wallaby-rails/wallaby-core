# frozen_string_literal: true

module Wallaby
  # Concern to handle the conversion between Class and String
  module Classifier
    # Convert String to Constant (Class/Module).
    # @param name [String]
    # @return [Class] if name is a Class
    # @raise [ArgumentError] if name is not a String
    def self.to_const(name, log: true)
      raise ArgumentError, 'Please provide a constant name in String.' unless name.is_a? String
      return Object.const_get name, false if Object.const_defined?(name, false)

      Logger.error "`#{name}` is not a valid Class name." if log
    end

    # Convert Class to String. If not Class, unchanged.
    # @param klass [Object]
    # @return [String] if klass is a Class
    # @return [Object] if klass is not a Class
    def to_class_name(klass)
      klass.try(:name) || klass || nil
    end

    # Convert String to Class. If not String, unchanged.
    # @param name [Object]
    # @return [Class] if name is a Class
    # @return [Object] if name is not a String
    # @return [nil] if class cannot be found
    def to_class(name)
      return name unless name.is_a? String

      Classifier.to_const name
    end
  end
end
