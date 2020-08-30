# frozen_string_literal: true

module Wallaby
  # URL service object for {Wallaby::Urlable#url_for} helper
  class EngineUrlFor
    include ActiveModel::Model

    attr_accessor :context
    attr_accessor :options
    attr_accessor :params

    # A constant to map actions to their route paths defined in Wallaby routes.
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

    # Generate URL that Wallaby engine supports (e.g. home/resourcesful/errors)
    # @see https://github.com/reinteractive/wallaby/blob/master/config/routes.rb config/routes.rb
    # @param context [ActionController::Base, ActionView::Base]
    # @param params [Hash, ActionController::Parameters]
    # @param options [Hash]
    # @return [String] Wallaby
    # @return [nil] nil if params is not a Hash or ActionController::Parameters
    def self.handle(context:, params:, options:, &block)
      return unless params.is_a?(Hash) || params.try(:permitted?)

      new(context: context, params: params, options: options).execute(&block)
    end

    def execute(&block)
      action_path && route && Engine.routes.url_helpers.try(
        action_path, **resources_param, **normalized_params
      ) || block.call(
        **controllers_param, **normalized_params
      )
    end

    private

    def action_path
      @action_path ||= ACTION_TO_PATH_MAP[
        params[:action] || params.fetch(:_recall, {})[:action]
      ]
    end

    def script_name
      @script_name ||= route.path.spec.to_s
    end

    def model_class
      options[:model_class]
    end

    def resources_param
      {}.tap do |params|
        params[:resources] = ModelUtils.to_resources_name(model_class) if model_class
      end
    end

    def controllers_param
      {}.tap do |params|
        params[:controller] = ModelUtils.to_controllers_name(model_class) if model_class
      end
    end

    def normalized_params
      ParamsUtils.presence(
        *(
          options[:with_query] && [context.request.query_parameters, context.url_options] || []
        ), params
      ).symbolize_keys.tap do |p|
        p[:script_name] = script_name if route
      end
    end

    def route
      Rails.application.routes.named_routes[engine_name]
    end

    def engine_name
      options[:engine_name] || context.try(:current_engine_name)
    end
  end
end
