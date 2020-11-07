# frozen_string_literal: true

module Wallaby
  # URL service object for {Urlable#url_for} helper
  #
  # Since {Engine}'s {https://github.com/wallaby-rails/wallaby-core/blob/master/config/routes.rb routes}
  # are declared in
  # {https://guides.rubyonrails.org/routing.html#routing-to-rack-applications Rack application}
  # fashion via {ResourcesRouter}.
  # It means when the current request is processed by {Engine},
  # using the original Rails **usl_for** (e.g. `url_for action: :index`)
  # will lead to an **ActionController::RoutingError** exception.
  #
  # To generate the proper URL from given params and options within the {Engine},
  # there are three kinds of scenarios that need to be considered
  # (assume that {Engine} is mounted at `/admin`):
  #
  # - if the URL to generate is a route that overrides the existing {Engine} route
  #   (assume that `categories` is one of the resources handled by {Engine}):
  #
  #   ```
  #   namespace :admin do
  #     resources :categories
  #   end
  #   wallaby_mount at: '/admin'
  #   ```
  #
  # - if the URL to generate is a regular route defined before mounting the {Engine}
  #   that does not override the resources `categories` routes handled by {Engine}, such as:
  #
  #   ```
  #   namespace :admin do
  #     resources :custom_categories
  #   end
  #   wallaby_mount at: '/admin'
  #   ```
  #
  # - regular resources handled by {Engine}, e.g. (`/admin/categories`)
  class EngineUrlFor
    include ActiveModel::Model

    # @!attribute context
    # @return [ActionController::Base, ActionView::Base]
    attr_accessor :context
    # @!attribute options
    # @return [Hash]
    attr_accessor :options
    # @!attribute params
    # @return [Hash, ActionController::Parameters]
    attr_accessor :params

    # A constant to map actions to its corresponding path helper methods
    # defined in {Engine}'s routes.
    # @see https://github.com/wallaby-rails/wallaby-core/blob/master/config/routes.rb
    ACTION_TO_URL_HELPER_MAP =
      Wallaby::ERRORS.each_with_object(ActiveSupport::HashWithIndifferentAccess.new) do |error, map|
        map[error] = :"#{error}_path"
      end.merge(
        home: :root_path,
        # for resourcesful actions
        index: :resources_path,
        new: :new_resource_path,
        show: :resource_path,
        edit: :edit_resource_path
      ).freeze

    # Generate the proper URL depending on the context
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

    # @return [String] URL
    # @return [nil] nil if current request is not under {Engine}
    # @see https://github.com/reinteractive/wallaby/blob/master/config/routes.rb
    def execute
      return if current_engine_route.blank?
      return url_for(other_route) if other_route.exist?
      return url_for(overridden_route) if overridden_route.exist?

      # NOTE: require to use `url_helper` here.
      # otherwise, {Engine} will raise **ActionController::UrlGenerationError**.
      Engine.routes.url_helpers.try(engine_action_url_helper, engine_params)
    end

    protected

    # @see OverriddenRoute
    def overridden_route
      @overridden_route ||= OverriddenRoute.new(
        script_name: script_name,
        model_class: model_class,
        action_name: action_name,
        resources_name: resources_name
      )
    end

    # @see OtherRoute
    def other_route
      @other_route ||= OtherRoute.new(
        script_name: script_name,
        model_class: model_class,
        current_model_class: context.try(:current_model_class),
        controller_path: controller_path,
        action_name: action_name
      )
    end

    # @param route [OverriddenRoute, OtherRoute]
    # @return [String] URL
    def url_for(route)
      route.url_for(
        ParamsUtils.presence(
          url_options, route.defaults, params
        ).deep_symbolize_keys
      )
    end

    # @return [Symbol] the URL helper for given action
    def engine_action_url_helper
      ACTION_TO_URL_HELPER_MAP[action_name.try(:to_sym)]
    end

    # @return [Hash] the params for the engine URL helper
    def engine_params
      ParamsUtils.presence(
        # script_name is required
        url_options, { script_name: script_name }, params
      ).deep_symbolize_keys.tap do |params|
        params[:resources] ||= resources_name if model_class
      end
    end

    # @return [Hash] url options
    def url_options
      context.default_url_options.merge(context.url_options).merge(
        options[:with_query] ? context.request.query_parameters : {}
      )
    end

    # @return [String] given controller param or current request's controller
    def controller_path
      @controller_path ||= (params[:controller] || recall[:controller]).to_s
    end

    # @return [String] given action param or current request's action
    def action_name
      @action_name ||= (params[:action] || recall[:action]).to_s
    end

    # @note This script name prefix is required for Rails
    # {https://api.rubyonrails.org/classes/ActionView/RoutingUrlFor.html#method-i-url_for #url_for}
    # to generate the correct URL.
    # @return [String] current engine's script name
    def script_name
      current_engine_route.path.spec.to_s
    end

    # @return [Class] model class option or converted model class from recall resources name
    def model_class
      @model_class ||= options[:model_class] || Map.model_class_map(recall[:resources])
    end

    # @return [String] resources name for given model
    def resources_name
      @resources_name ||= Inflector.to_resources_name(model_class)
    end

    # @return [ActionDispatch::Journey::Route] engine route for current request
    def current_engine_route
      Rails.application.routes.named_routes[context.try(:current_engine_name)]
    end

    # Recall is the path params of current request
    # @see https://github.com/rails/rails/blob/master/actionpack/lib/action_controller/metal/url_for.rb#L35
    def recall
      @recall ||= context.url_options[:_recall] || {}
    end
  end
end
