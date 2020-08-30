# frozen_string_literal: true

module Wallaby
  # Defaults related methods
  module Defaultable
    protected

    # Set default options for create action
    # @param options [Hash]
    # @return [Hash] updated options with default values
    def set_defaults_for(action, options)
      case action.try(:to_sym)
      when :create, :update then assign_create_and_update_defaults_with options
      when :destroy then assign_destroy_defaults_with options
      end
      options
    end

    # @param options [Hash]
    # @return [Hash] updated options with default values
    def assign_create_and_update_defaults_with(options)
      options[:params] ||= resource_params
      options[:location] ||= -> { show_path resource }
    end

    # @param options [Hash]
    # @return [Hash] updated options with default values
    def assign_destroy_defaults_with(options)
      options[:params] ||= params
      options[:location] ||=
        params[:resource] ? show_path(resource) : index_path(current_model_class)
    end
  end
end
