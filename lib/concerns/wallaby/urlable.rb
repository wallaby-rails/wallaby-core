# frozen_string_literal: true

module Wallaby
  # All URL helpers
  module Urlable
    # Override origin method to handle URL for Wallaby engine.
    #
    # As Wallaby's routes are declared in a
    # {https://guides.rubyonrails.org/routing.html#routing-to-rack-applications Rack application} fashion, this will
    # lead to **ActionController::RoutingError** exception when using ordinary **url_for**
    # (e.g. `url_for action: :index`).
    #
    # Gotcha: Wallaby can't cope well with the following situation.
    # It's due to the limit of route declaration and matching:
    #
    # ```
    # scope path: '/prefix' do
    #   wresources :products, controller: 'wallaby/resources'
    # end
    # ```
    # @param options [String, Hash, ActionController::Parameters]
    # @option options [Boolean]
    #   :with_query to include `request.query_parameters` values for url generation.
    # @option options [String]
    #   :engine_name to specify the engine_name to use, default to {Wallaby::Engineable#current_engine_name}
    # @return [String] URL string
    # @see Wallaby::EngineUrlFor.handle
    # @see https://api.rubyonrails.org/classes/ActionView/RoutingUrlFor.html#method-i-url_for
    #   ActionView::RoutingUrlFor#url_for
    def url_for(options = nil)
      if options.is_a?(Hash) || options.try(:permitted?)
        # merge with all current query parameters
        options = request.query_parameters.merge(options) if options.delete(:with_query)
        options = ParamsUtils.presence url_options, options # remove blank values
        EngineUrlFor.handle(
          engine_name: options.fetch(:engine_name, current_engine_name), parameters: options
        )
      end || super
    end

    # @param model_class [Class]
    # @param url_params [Hash]
    # @return [String] index page path
    def index_path(model_class, url_params: {})
      hash = ParamsUtils.presence(
        { action: :index },
        default_path_params(resources: ModelUtils.to_resources_name(model_class)),
        url_params.to_h
      )
      current_engine.try(:resources_path, hash) || url_for(hash)
    end

    # @param model_class [Class]
    # @param url_params [Hash]
    # @return [String] new page path
    def new_path(model_class, url_params: {})
      hash = ParamsUtils.presence(
        { action: :new },
        default_path_params(resources: ModelUtils.to_resources_name(model_class)),
        url_params.to_h
      )

      current_engine.try(:new_resource_path, hash) || url_for(hash)
    end

    # @param resource [Object]
    # @param is_resource [Boolean]
    # @param url_params [Hash]
    # @return [String] show page path
    def show_path(resource, is_resource: false, url_params: {})
      decorated = decorate resource
      return unless is_resource || decorated.primary_key_value

      hash = ParamsUtils.presence(
        { action: :show, id: decorated.primary_key_value },
        default_path_params(resources: decorated.resources_name),
        url_params.to_h
      )

      current_engine.try(:resource_path, hash) || url_for(hash)
    end

    # @param resource [Object]
    # @param is_resource [Boolean]
    # @param url_params [Hash]
    # @return [String] edit page path
    def edit_path(resource, is_resource: false, url_params: {})
      decorated = decorate resource
      return unless is_resource || decorated.primary_key_value

      hash = ParamsUtils.presence(
        { action: :edit, id: decorated.primary_key_value },
        default_path_params(resources: decorated.resources_name),
        url_params.to_h
      )

      current_engine.try(:edit_resource_path, hash) || url_for(hash)
    end

    # @return [Hash] default path params
    def default_path_params(resources: nil)
      { script_name: request.env[SCRIPT_NAME] }.tap do |default|
        default[:resources] = resources if current_engine_name.present? && resources
        default[:only_path] = true unless default.key?(:only_path)
      end
    end
  end
end
