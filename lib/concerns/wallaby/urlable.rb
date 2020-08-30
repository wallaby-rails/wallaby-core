# frozen_string_literal: true

module Wallaby
  # All URL helpers for {Engine}
  module Urlable
    # Override original method to handle URL generation **when Wallaby is used as Rails Engine**.
    #
    # Wallaby's {https://github.com/wallaby-rails/wallaby-core/blob/master/config/routes.rb routes} are declared in
    # {https://guides.rubyonrails.org/routing.html#routing-to-rack-applications Rack application} fashion.
    # When {Engine} is mounted, it requires the `:resources` parameter.
    #
    # Therefore, using the original **usl_for** without the parameter (e.g. `url_for action: :index`)
    # will lead to **ActionController::RoutingError** exception.
    # @param options [String, Hash, ActionController::Parameters]
    # @option options [Boolean] :with_query see {#with_query}
    # @option options [String]
    #   :engine_name to specify the engine_name to use, default to {Engineable#current_engine_name}
    # @return [String] URL string
    # @see EngineUrlFor.handle
    # @see https://api.rubyonrails.org/classes/ActionView/RoutingUrlFor.html#method-i-url_for
    #   ActionView::RoutingUrlFor#url_for
    def url_for(options = nil)
      EngineUrlFor.handle(context: self, options: options) || super
    end

    # @see Map.resources_name_map
    # @return [String] resources name for given model class
    def to_resources_name(model_class)
      Map.resources_name_map model_class
    end

    # This provides the feature to include all query parameters for given url params.
    # @param url_params [Hash, ActionController::Parameters]
    # @option url_params [Boolean]
    #   :with_query to include request's **query_parameters** if true.
    # @param url_options [Hash, ActionController::Parameters]
    # @return [Hash] new params
    def with_query(url_params, url_options: {})
      ParamsUtils.presence(
        url_options,
        url_params.delete(:with_query) ? request.query_parameters.merge(url_params) : url_params
      )
    end

    # Generate the resourcesful index path for given model class.
    # @param model_class [Class]
    # @param url_params [Hash]
    # @option url_params [Boolean] :with_query see {#with_query}
    # @return [String] index page path
    def index_path(model_class, url_params: {})
      url_params = with_query url_params
      current_engine.try(:resources_path, {
        resources: to_resources_name(model_class), script_name: request.script_name
      }.merge(url_params)) || url_for({
        controller: ModelUtils.to_controllers_name(model_class), action: :index
      }.merge(url_params))
    end

    # Generate the resourcesful new path for given model class.
    # @param model_class [Class]
    # @param url_params [Hash]
    # @option url_params [Boolean] :with_query see {#with_query}
    # @return [String] new page path
    def new_path(model_class, url_params: {})
      url_params = with_query url_params
      current_engine.try(:new_resource_path, {
        resources: to_resources_name(model_class), script_name: request.script_name
      }.merge(url_params)) || url_for({
        controller: ModelUtils.to_controllers_name(model_class), action: :new
      }.merge(url_params))
    end

    # Generate the resourcesful show path for given resource.
    # @param resource [Object]
    # @param url_params [Hash]
    # @option url_params [Boolean] :with_query see {#with_query}
    # @return [String] show page path
    def show_path(resource, url_params: {})
      decorated = decorate resource
      id = decorated.primary_key_value
      url_params = with_query url_params
      current_engine.try(:resource_path, {
        resources: to_resources_name(decorated.model_class), id: id, script_name: request.script_name
      }.merge(url_params)) || url_for({
        controller: ModelUtils.to_controllers_name(decorated.model_class), action: :show, id: id
      }.merge(url_params))
    end

    # Generate the resourcesful edit path for given resource.
    # @param resource [Object]
    # @param url_params [Hash]
    # @option url_params [Boolean] :with_query see {#with_query}
    # @return [String] edit page path
    def edit_path(resource, url_params: {})
      decorated = decorate resource
      id = decorated.primary_key_value
      url_params = with_query url_params
      current_engine.try(:edit_resource_path, {
        resources: to_resources_name(decorated.model_class), id: id, script_name: request.script_name
      }.merge(url_params)) || url_for({
        controller: ModelUtils.to_controllers_name(decorated.model_class), action: :edit, id: id
      }.merge(url_params))
    end
  end
end
