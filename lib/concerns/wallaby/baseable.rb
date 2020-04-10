# frozen_string_literal: true

module Wallaby
  # Abstract related class methods
  module Baseable
    SUFFIX = /(Controller|Decorator|Servicer|Authorizer|Paginator)$/.freeze
    ATTR_NAME = 'model_class'

    # @param class_name [String]
    # @param attr_name [String]
    # @param suffix [String]
    # @param plural [String]
    # @return [Class] found associated class
    # @raise [Wallaby::ClassNotFound] if associated class isn't found
    def self.guess_associated_class_of(class_name, attr_name: ATTR_NAME, suffix: EMPTY_STRING, plural: false)
      base_name = class_name.gsub(SUFFIX, EMPTY_STRING).try(plural ? :pluralize : :singularize) << suffix
      parts = base_name.split(COLONS)
      parts.each_with_index do |_, index|
        # NOTE: DO NOT try to use const_defined? and const_get EVER.
        # This is Rails, use constantize
        return parts[index..-1].join(COLONS).constantize
      rescue NameError # rubocop:disable Lint/SuppressedException
      end

      raise ClassNotFound, <<~INSTRUCTION
        The `#{attr_name}` hasn't been provided for Class `#{class_name}` and Wallaby cannot guess it right.
        If `#{class_name}` is supposed to be a base class, add the following line to its class declaration:

          class #{class_name}
            base_class!
          end

        Otherwise, please specify the `#{attr_name}` in `#{class_name}`'s declaration as follows:

          class #{class_name}
            self.#{attr_name} = CorrectClass
          end
      INSTRUCTION
    end

    # Configurable attributes:
    # 1. mark a class as a base class
    # 2. guess the model class if model class isn't given
    module ClassMethods
      # @return [true] if class is a base class
      # @return [false] if class is not a base class
      def base_class?
        @base_class == self
      end

      # Mark the current class as the base class
      def base_class!
        @base_class = self
      end

      # @!attribute [r] base_class
      # @return [Class] The base class or the one from super class
      def base_class
        @base_class || superclass.try(:base_class)
      end

      # @!attribute [w] model_class
      def model_class=(model_class)
        raise ArgumentError 'Please provide a Class for `model_class`.' unless model_class.is_a? Class

        @model_class = model_class
      end

      # @!attribute [r] model_class
      # @example To configure the model class
      #   class Admin::ProductAuthorizer < Admin::ApplicationAuthorizer
      #     self.model_class = Product
      #   end
      # @example To configure the model class for version below 5.2.0
      #   class Admin::ProductAuthorizer < Admin::ApplicationAuthorizer
      #     def self.model_class
      #       Product
      #     end
      #   end
      # @return [Class] assigned model class or Wallaby will guess it
      #   (see {Wallaby::Baseable.guess_associated_class_of .guess_associated_class_of})
      # @return [nil] if current class is marked as base class
      # @raise [Wallaby::ModelNotFound] if model class isn't found
      # @raise [ArgumentError] if base class is empty
      def model_class
        return if base_class?

        @model_class ||= Baseable.guess_associated_class_of name
      rescue TypeError
        raise ArgumentError, <<~INSTRUCTION
          Please specify the base class for class `#{name}`
          by marking one of its parents `base_class!`, for example:

            class ParentClass
              base_class!
            end
        INSTRUCTION
      end

      # @!attribute [w] namespace
      # Used by `model_class`
      # @since wallaby-5.2.0
      attr_writer :namespace

      # @!attribute [r] namespace
      # @return [String] namespace
      # @since wallaby-5.2.0
      def namespace
        @namespace ||=
          superclass.try(:namespace) \
            || name.deconstantize.gsub(/Wallaby(::)?/, EMPTY_STRING).presence
      end
    end
  end
end
