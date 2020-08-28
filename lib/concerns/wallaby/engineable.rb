# frozen_string_literal: true

module Wallaby
  # Engine related helper methods for both controller and view
  module Engineable
    # This engine helper is used to access URL helpers of Wallaby engine.
    #
    # Considering **Wallaby** is mounted at the following paths:
    #
    # ```
    # mount Wallaby::Engine, at: '/admin'
    # mount Wallaby::Engine, at: '/inner', as: :inner_engine, defaults: { resources_controller: InnerController }
    # ```
    #
    # If `/inner` is current script name, `current_engine` is same as `inner_engine`.
    # Then it's possible to access URL helpers like this:
    #
    # ```
    # current_engine.resources_path resources: 'products'
    # ```
    # @return [ActionDispatch::Routing::RoutesProxy] engine for current request
    def current_engine
      @current_engine ||= try current_engine_name
    end

    # Find out the engine name for the current request, it comes from either:
    # - {Wallaby::Configurable#engine_name}
    # - Judge from the request path (which includes the script and path info)
    # @return [String] engine name for current request
    def current_engine_name
      @current_engine_name ||= controller_configuration.engine_name || EngineNameFinder.find(request.path)
    end
  end
end
