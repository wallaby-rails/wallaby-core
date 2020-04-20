# frozen_string_literal: true

module Wallaby
  # Wallaby application helper
  module ApplicationHelper
    include ConfigurationHelper
    include Engineable
    include SharedHelpers

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
      end || super(options)
    end

    # Override origin method to add turbolinks tracking when it's enabled
    # @param sources [Array<String>]
    # @return [String] stylesheet link tags HTML
    def stylesheet_link_tag(*sources)
      default_options =
        features.turbolinks_enabled ? { 'data-turbolinks-track' => true } : {}
      options = default_options.merge!(sources.extract_options!.stringify_keys)
      super(*sources, options)
    end

    # Override origin method to add turbolinks tracking when it's enabled
    # @param sources [Array<String>]
    # @return [String] javascript script tags HTML
    def javascript_include_tag(*sources)
      default_options =
        features.turbolinks_enabled ? { 'data-turbolinks-track' => true, 'data-turbolinks-eval' => false } : {}
      options = default_options.merge!(sources.extract_options!.stringify_keys)
      super(*sources, options)
    end

    # @param key
    # @param options [Hash]
    def wt(key, options = {})
      Locale.t key, { translator: method(:t) }.merge(options)
    end
  end
end
