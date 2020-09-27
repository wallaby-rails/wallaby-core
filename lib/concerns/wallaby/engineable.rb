# frozen_string_literal: true

module Wallaby
  # {Wallaby::Engine} related helper methods to be included for both controller and view.
  module Engineable
    # This helper method returns the current {Wallaby::Engine} routing proxy.
    # For example, if {Wallaby} is mounted at different paths at the same time:
    #
    # ```
    # mount Wallaby::Engine, at: '/admin'
    # mount Wallaby::Engine, at: '/inner', as: :inner_engine,
    #   defaults: { resources_controller: InnerController }
    # ```
    #
    # If `/inner` is current request path, it returns `inner_engine` engine proxy.
    # @return [ActionDispatch::Routing::RoutesProxy] engine proxy for current request
    def current_engine
      @current_engine ||= try current_engine_name
    end

    # Find out the {Wallaby::Engine} routing proxy name for the current request, it comes from either:
    #
    # - Current controller's {Wallaby::Configurable::ClassMethods#engine_name engine_name}
    # - Judge from the current request path (which contains the script and path info)
    # @return [String] engine name for current request
    # @see Wallaby::EngineNameFinder.execute
    def current_engine_name
      @current_engine_name ||= controller_configuration.engine_name || EngineNameFinder.execute(request.path)
    end
  end
end
