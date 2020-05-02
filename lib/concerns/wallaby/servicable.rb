# frozen_string_literal: true

module Wallaby
  # Servicer related attributes
  module Servicable
    # Model servicer for current modal class. It comes from:
    #
    # - controller configuration {Wallaby::Configurable::ClassMethods#model_servicer .model_servicer}
    # - a generic servicer based on {Wallaby::Configurable::ClassMethods#application_servicer .application_servicer}
    # @return [Wallaby::ModelServicer] model servicer
    # @since wallaby-5.2.0
    def current_servicer
      @current_servicer ||=
        (controller_configuration.model_servicer \
          || Map.servicer_map(current_model_class, controller_configuration.application_servicer)).try do |klass|
          Logger.debug %(Current servicer: #{klass}), sourcing: false
          klass.new current_model_class, current_authorizer, current_model_decorator
        end
    end
  end
end
