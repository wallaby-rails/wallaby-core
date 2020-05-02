# frozen_string_literal: true

module Wallaby
  # All the lookups that Wallaby needs.
  class Map
    class << self
      include Classifier

      # @!attribute [w] modes
      attr_writer :modes

      # @!attribute [r] modes
      # @return [Array<String>] all {Wallaby::Mode}s
      def modes
        @modes ||= ClassArray.new Mode.descendants
      end

      # @return [Wallaby::ClassHash] { Model Class => {Wallaby::Mode} }
      def mode_map
        @mode_map ||= ModeMapper.execute(modes).freeze
      end

      # @deprecated
      # @return [Array] [ model classes ]
      def model_classes
        Deprecator.alert method(__callee__), from: '0.2.2'
      end

      # { model => resources name }
      # It's a setter when value is given.
      # Otherwise, a getter.
      # @param model_class [Class]
      # @param value [String, nil] resources name
      # @return [String] resources name
      def resources_name_map(model_class, value = nil)
        @resources_name_map ||= ClassHash.new
        @resources_name_map[model_class] ||= value || ModelUtils.to_resources_name(model_class)
      end

      # { resources name => model }
      # It's a setter when value is given.
      # Otherwise, a getter.
      # @param resources_name [String]
      # @return [Class]
      def model_class_map(resources_name, value = nil)
        @model_class_map ||= ClassHash.new
        @model_class_map[resources_name] ||= value || ModelUtils.to_model_class(resources_name)
      end
    end

    class << self
      # Look up which controller to use for a given model class
      # @param model_class [Class]
      # @param application_controller [Class]
      # @return [Class] controller class
      def controller_map(model_class, application_controller)
        map_of :@controller_map, model_class, application_controller
      end

      # Look up which resource decorator to use for a given model class
      # @param model_class [Class]
      # @param application_decorator [Class]
      # @return [Class] resource decorator class
      def resource_decorator_map(model_class, application_decorator)
        map_of :@resource_decorator_map, model_class, application_decorator
      end

      # { model => model decorator }
      # @param model_class [Class]
      # @param application_decorator [Class]
      # @return [Wallaby::ModelDecorator] model decorator instance
      def model_decorator_map(model_class, application_decorator)
        @model_decorator_map ||= ClassHash.new
        @model_decorator_map[application_decorator] ||= ClassHash.new
        @model_decorator_map[application_decorator][model_class] ||=
          mode_map[model_class].try(:model_decorator).try :new, model_class
      end

      # Look up which model servicer to use for a given model class
      # @param model_class [Class]
      # @param application_servicer [Class]
      # @return [Class] model servicer class
      def servicer_map(model_class, application_servicer)
        map_of :@servicer_map, model_class, application_servicer
      end

      # Look up which paginator to use for a given model class
      # @param model_class [Class]
      # @param application_paginator [Class]
      # @return [Class] resource paginator class
      def paginator_map(model_class, application_paginator)
        map_of :@paginator_map, model_class, application_paginator
      end

      # Look up which authorizer to use for a given model class
      # @param model_class [Class]
      # @param application_authorizer [Class]
      # @return [Class] model authorizer class
      def authorizer_map(model_class, application_authorizer)
        map_of :@authorizer_map, model_class, application_authorizer
      end
    end

    class << self
      # { model => service_provider }
      # @param model_class [Class]
      # @return [Class] model service provider instance
      def service_provider_map(model_class)
        @service_provider_map ||= ClassHash.new
        @service_provider_map[model_class] ||= mode_map[model_class].try :model_service_provider
      end

      # { model => pagination_provider }
      # @param model_class [Class]
      # @return [Class] model pagination provider class
      def pagination_provider_map(model_class)
        @pagination_provider_map ||= ClassHash.new
        @pagination_provider_map[model_class] ||= mode_map[model_class].try :model_pagination_provider
      end

      # { model => authorizer_provider }
      # @param model_class [Class]
      # @return [Class] model authorizer provider class
      def authorizer_provider_map(model_class)
        @authorizer_provider_map ||= ClassHash.new
        @authorizer_provider_map[model_class] ||= mode_map[model_class].try :model_authorization_providers
      end
    end

    class << self
      # Reset all the instance variables to nil
      def clear
        instance_variables.each { |name| instance_variable_set name, nil }
      end

      private

      # Set up the hash map for given variable name
      # @param variable_name [Symbol] instance variable name e.g. :@decorator_map
      # @param model_class [Class]
      # @param application_class [Class]
      # @return [Class]
      def map_of(variable_name, model_class, application_class)
        return unless model_class

        unless mode_map[model_class]
          Logger.warn Locale.t('map.missing_mode_for_model_class', model: model_class.name), sourcing: 2..5
          return
        end
        instance_variable_set(variable_name, instance_variable_get(variable_name) || ClassHash.new)
        map = instance_variable_get variable_name
        map[application_class] ||= ModelClassMapper.map application_class.descendants
        map[application_class][model_class] ||= application_class
      end
    end
  end
end
