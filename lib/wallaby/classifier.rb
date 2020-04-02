# frozen_string_literal: true

module Wallaby
  # Module that can be included to handle the conversion between Class and String
  module Classifier
    def to_class_name(klass)
      klass.try(:name) || klass || nil
    end

    def to_class(name)
      return name if name.is_a? Class

      name.try(:constantize)
    end

    def as_class_name
      method(:to_class_name)
    end

    def as_class
      method(:to_class)
    end
  end
end
