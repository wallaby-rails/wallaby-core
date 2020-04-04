# frozen_string_literal: true

module Wallaby
  # Utils for model
  module ModelUtils
    class << self
      # Guess model class for given class. If NameError is raised, it means either the
      # @param class_name [String]
      # @param regexp [Regexp]
      # @return [Class]
      def guess_model_class(class_name, regexp)
        model_name = class_name.gsub(regexp, EMPTY_STRING)
        Map.model_class_map model_name
      rescue NameError => e
        raise NameError, <<~INSTRUCTION

          Got this NameError: #{e.message}

          Wallaby guesses the `model_class` as `#{model_name}` for class `#{class_name}` and doesn't get it right.

          Please speicify the correct `model_class` in `#{class_name}`, for example:

            self.model_class = CorrectModelClass

          Or check if class name `#{class_name}` is correct or not.

        INSTRUCTION
      end

      # Convert model class (e.g. `Namespace::Product`) into resources name (e.g. `namespace::products`)
      # @param model_class [Class, String] model class
      # @return [String] resources name
      def to_resources_name(model_class)
        return EMPTY_STRING if model_class.blank?

        model_class.to_s.underscore.gsub(SLASH, COLONS).pluralize
      end

      # Produce model label (e.g. `Namespace / Product`) for model class (e.g. `Namespace::Product`)
      # @param model_class [Class, String] model class
      # @return [String] model label
      def to_model_label(model_class)
        # TODO: change to use i18n translation
        return EMPTY_STRING if model_class.blank?

        model_class_name = to_model_name model_class
        model_class_name.titleize.gsub(SLASH, SPACE + SLASH + SPACE)
      end

      # Convert resources name (e.g. `namespace::products`) into model class (e.g. `Namespace::Product`)
      # @param resources_name [String] resources name
      # @return [Class] model class
      # @return [nil] when not found
      def to_model_class(resources_name)
        return if resources_name.blank?

        class_name = to_model_name resources_name
        class_name.constantize
      end

      # Convert resources name (e.g. `namespace::products`) into model name (e.g. `Namespace::Product`)
      # @param resources_name [String] resources name
      # @return [String] model name
      def to_model_name(resources_name)
        return EMPTY_STRING if resources_name.blank?

        resources_name.to_s.singularize.gsub(COLONS, SLASH).camelize
      end
    end
  end
end
