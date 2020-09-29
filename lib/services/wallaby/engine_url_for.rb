# frozen_string_literal: true

module Wallaby
  # URL service object for {Urlable#url_for} helper
  #
  # Since {Wallaby}'s {https://github.com/wallaby-rails/wallaby-core/blob/master/config/routes.rb routes}
  # are declared in
  # {https://guides.rubyonrails.org/routing.html#routing-to-rack-applications Rack application} fashion.
  # When {Engine} is mounted, it requires the `:resources` parameter.
  #
  # Therefore, using the original **usl_for** without the `:resources` parameter (e.g. `url_for action: :index`)
  # will lead to **ActionController::RoutingError** exception.
  #
  # And this is what this service object is trying to tackle.
  class EngineUrlFor
    include ActiveModel::Model

    attr_accessor :context
    attr_accessor :options
    attr_accessor :params

    # A constant to map actions to its corresponding path helper methods
    # defined in {Engine}'s routes.
    # @see https://github.com/wallaby-rails/wallaby-core/blob/master/config/routes.rb
    ACTION_TO_PATH_MAP =
      Wallaby::ERRORS.each_with_object(ActiveSupport::HashWithIndifferentAccess.new) do |error, map|
        map[error] = :"#{error}_path"
      end.merge(
        home: :root_path,
        index: :resources_path,
        new: :new_resource_path,
        show: :resource_path,
        edit: :edit_resource_path
      ).freeze

    # Generate URL that {Engine} recognizes (e.g. home/resourcesful/errors) including the routes
    # that have been defined by {ActionDispatch::Routing::Mapper#wallaby_mount #wallaby_mount}
    # @param context [ActionController::Base, ActionView::Base]
    # @param params [Hash, ActionController::Parameters]
    # @param options [Hash]
    # @option model_class [Class]
    # @option with_query [true] indicate if all query params should be included
    # @return [nil] nil if params is not a **Hash** or **ActionController::Parameters**
    # @see #execute
    def self.execute(context:, params:, options:)
      return unless params.is_a?(Hash) || params.try(:permitted?)

      new(context: context, params: params, options: options).execute
    end

    # This method only take cares the requests processed by {Engine}:
    #
    # 1. the given params matches the route defined using
    # {ActionDispatch::Routing::Mapper#wallaby_mount #wallaby_mount} block
    # in Rails application **config/routes.rb**
    # 2. the given params matches the route defined for {ResourcesRouter}
    # @return [String] {Engine}'s URL
    # @return [nil] nil if current request is not under {Engine}
    # @see https://github.com/reinteractive/wallaby/blob/master/config/routes.rb
    def execute
      return unless engine_route
      return Engine.routes.url_for(**overridden_route.defaults, **normalized_params) if overridden_route.present?

      Engine.routes.url_helpers.try(action_path, **resources_param, **normalized_params)
    end

    protected

    # Check if given params meet any of the routes defined by
    # {ActionDispatch::Routing::Mapper#wallaby_mount #wallaby_mount}
    def overridden_route
      return unless possible_controller_path

      @overridden_route ||=
        Engine.routes.routes.find do |route|
          # if route is defined in this ordinary way e.g. `resources :products` before ResourcesRouter is defined,
          # it will always include `:controller` and `:action` in the route's `defaults` options.
          # for ResourcesRouter, it can only have `:action` in the `defaults` options
          # so we can use `:controller` and `:action` pair to
          route.defaults[:action] == action_name && route.defaults[:controller] == possible_controller_path
        end
    end

    def action_path
      ACTION_TO_PATH_MAP[action_name.try(:to_sym)]
    end

    def resources_param
      params = {}
      params[:resources] = ModelUtils.to_resources_name(model_class) if model_class
      params[:resources] ||= recall[:resources] if required_keys.try(:include?, :resources)
      params[:id] ||= recall[:id] if required_keys.try(:include?, :id)
      params
    end

    def normalized_params
      ParamsUtils.presence(*params_list).symbolize_keys.tap do |p|
        # script_name is required for {Engine}'s url_for to work properly
        p[:script_name] ||= script_name if engine_route
        # this is required if Rails version is lower than 5
        p[:host] ||= context.url_options[:host]
      end
    end

    # @return given action param or current request's action
    def action_name
      @action_name ||= (params[:action] || recall[:action]).to_s
    end

    # @note This script name prefix is required for Rails
    # {https://api.rubyonrails.org/classes/ActionView/RoutingUrlFor.html#method-i-url_for #url_for}
    # to generate the correct URL.
    # Current engine's script name prefix.
    def script_name
      engine_route.path.spec.to_s
    end

    def model_class
      @model_class ||= options[:model_class] || Map.model_class_map(recall[:resources])
    end

    def params_list
      list = [params, context.default_url_options]
      list.unshift(context.request.query_parameters) if options[:with_query]
      list
    end

    def possible_controller_path
      @possible_controller_path ||= begin
        controller = Map.controller_map(model_class, Wallaby.controller_configuration.base_class)
        controller && !controller.base_class? && controller.try(:controller_path) \
          || ModelUtils.to_controllers_name(model_class)
      end
    end

    # @return [ActionDispatch::Journey::Route] the target route associated with the {#action_name}
    #   defined by {ResourcesRouter}
    def target_route
      @target_route ||=
        (Engine.routes.routes.find { |route| route.defaults[:action] == action_name } if overridden_route.blank?)
    end

    def required_keys
      target_route.try(:required_keys)
    end

    def engine_route
      Rails.application.routes.named_routes[context.try(:current_engine_name)]
    end

    # Recall is the url option that stores the params of current request
    def recall
      @recall ||= context.url_options[:_recall] || {}
    end
  end
end
