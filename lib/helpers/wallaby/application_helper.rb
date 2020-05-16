# frozen_string_literal: true

module Wallaby
  # Wallaby application helper
  module ApplicationHelper
    include ConfigurationHelper
    include Engineable

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

    # Override origin #form_for method to provide default form builder
    # @param record [ActiveRecord::Base, String, Symbol]
    # @param options [Hash]
    def form_for(record, options = {}, &block)
      options[:builder] ||= FormBuilder
      super
    end

    # I18n transaltion just for Wallaby
    # @param key
    # @param options [Hash]
    # @return [String] transaltion for given key
    def wt(key, options = {})
      Locale.t key, { translator: method(:t) }.merge(options)
    end
  end
end
