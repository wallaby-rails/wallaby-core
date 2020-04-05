# frozen_string_literal: true

module Wallaby
  # Concern to handle the conversion between Class and String
  module Classifier
    # Convert Class to String. If not Class, unchanged.
    # @param klass [Object]
    # @return [String] if klass is a Class
    # @return [Object] if klass is not a Class
    def to_class_name(klass)
      klass.try(:name) || klass || nil
    end

    # Convert String to Class. If not String, unchanged.
    # @param name [Object]
    # @return [Class] if name is a String
    # @return [Object] if name is not a String
    def to_class(name)
      return name unless name.is_a? String

      name.constantize
    rescue NameError
      Logger.error "`#{val}` is not a valid Class name."
    end
  end
end
