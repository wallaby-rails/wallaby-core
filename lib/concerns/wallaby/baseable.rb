# frozen_string_literal: true

module Wallaby
  # Abstract related class methods
  module Baseable
    SUFFIX = /(Controller|Decorator|Servicer|Authorizer|Paginator)$/.freeze

    # @param class_name [String]
    # @return [Class] found associated model class
    # @raise [Wallaby::ModelNotFound] if model class isn't found
    def self.guess_model_class_from(class_name)
      base_name = class_name.gsub(SUFFIX, EMPTY_STRING).singularize
      parts = base_name.split COLONS
      name_found =
        parts
        .each_with_index
        .each_with_object([]) { |(_, index), classes| classes << parts[index..-1].join(COLONS) }
        .find(&method(:const_defined?))
      return const_get(name_found) if name_found

      raise ModelNotFound, <<~INSTRUCTION
        The model class isn't provided for Class `#{class_name}` and Wallaby cannot guess it right.
        Please specify the `model_class` in Class `#{class_name}`'s declaration as below example:

          self.model_class = CorrectModelClass

        Or mark Class `#{class_name}` as the base class in its class declaration:

          base_class!
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
      # @return [Class] assigned model class or Wallaby will guess it (see {Wallaby::Baseable.guess_model_class_from})
      # @return [nil] if current class is marked as base class
      # @raise [Wallaby::ModelNotFound] if model class isn't found
      def model_class
        return unless self < base_class

        @model_class ||= Baseable.guess_model_class_from(name)
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
