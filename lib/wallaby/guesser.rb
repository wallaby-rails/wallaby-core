# frozen_string_literal: true

module Wallaby
  # Guess the associated class for give class
  class Guesser
    SUFFIX = /(Controller|Decorator|Servicer|Authorizer|Paginator)$/.freeze # :no_doc:

    class << self
      # Guess the associated class for give class. For example, if given class is **Admin::Order::ItemsController**,
      # then it will try to constantize the following class name
      # and return the first one that is successfully constantized:
      #
      # - Admin::Order::Item
      # - Order::Item
      # - Item
      # @param class_name [String]
      # @param suffix [String]
      # @param super_class [Class]
      # @return [Class] found associated class
      # @return [nil] if not found
      def class_for(
        class_name, suffix: EMPTY_STRING, super_class: nil
      )
        base_name = class_name.gsub(SUFFIX, EMPTY_STRING).singularize << suffix
        parts = base_name.split COLONS
        parts.each_with_index do |_, index|
          klass = constantize parts[index..-1].join(COLONS)
          next unless klass
          # check superclass inheritance
          next if super_class && klass >= super_class
          # additional checking, the given block should return true to continue
          next if block_given? && !yield(klass)

          return klass
        end

        nil
      end

      # Constructure the decorator by script name and model class. If the desired decorator
      # class not exists, fallback to the application decorator.
      # @param script_name [String]
      # @param model_class [Class]
      # @param application_decorator [Class]
      # @return [Class] decorator class
      def decorator_for(script_name:, model_class:, current_model_class:, controller_class:)
        model_class == current_model_class && controller_class.resource_decorator || \
          constantize(Inflector.to_decorator_name(script_name, model_class)) do |class_name|
            Logger.hint(:customize_decorator, <<~INSTRUCTION
              HINT: To customize the decorator for model `#{model_class}`, create:

                class #{class_name} < #{controller_class.application_decorator}
                end
            INSTRUCTION
            )
          end || controller_class.application_decorator
      end

      # Constructure the authorizer by script name and model class. If the desired authorizer
      # class not exists, fallback to the application authorizer.
      # @param script_name [String]
      # @param model_class [Class]
      # @param application_authorizer [Class]
      # @return [Class] authorizer class
      def authorizer_for(script_name:, model_class:, current_model_class:, controller_class:)
        model_class == current_model_class && controller_class.resource_decorator || \
          constantize(Inflector.to_authorizer_name(script_name, model_class)) do |class_name|
            Logger.hint(:customize_authorizer, <<~INSTRUCTION
              HINT: To customize the authorizer for model `#{model_class}`, create:

                class #{class_name} < #{controller_class.application_authorizer}
                end
            INSTRUCTION
            )
          end || controller_class.application_authorizer
      end

      protected

      # Constantize the class name
      # @return [Class] if class name is valid
      # @return [nil] otherwise
      def constantize(class_name)
        # NOTE: DO NOT try to use const_defined? and const_get EVER.
        # Using constantize is Rails way to make it require the corresponding file.
        class_name.constantize
      rescue NameError
        yield(class_name) if block_given?
        nil
      end
    end
  end
end
