module Wallaby
  class DecoratorFinder < ClassFinder
    def execute
      controller_class.resource_decorator ||
      possible_default_class ||
      controller_class.application_decorator
    end

    protected

    def controller_class
      @controller_class ||= ControllerFinder.new(
        script_name: script_name,
        model_class: model_class,
        current_controller_class: current_controller_class
      ).execute
    end
  end
end
