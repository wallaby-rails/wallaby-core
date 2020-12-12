# frozen_string_literal: true

module Wallaby
  # Default options for different action
  module Defaultable
    protected

    # Set default options e.g.(`:params`, `:location`) for
    # #{ResourcesConcern#create #create}/#{ResourcesConcern#update #update}/#{ResourcesConcern#destroy #destroy}
    # @param action [String, Symbol]
    # @param options [Hash]
    # @return [Hash] updated options with default values
    # @see ResourcesConcern#create
    # @see ResourcesConcern#update
    # @see ResourcesConcern#destroy
    def set_defaults_for(action, options)
      case action.try(:to_sym)
      when :create, :update
        options[:params] ||= resource_params
        options[:location] ||= -> { show_path resource }
      when :destroy
        options[:params] ||= params
        options[:location] ||= -> { index_path current_model_class }
      end
      options
    end
  end
end
