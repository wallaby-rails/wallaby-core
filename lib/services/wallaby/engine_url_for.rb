# frozen_string_literal: true

module Wallaby
  # URL service object for {Wallaby::Urlable#url_for} helper
  class EngineUrlFor
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

    class << self
      # Generate URL that Wallaby engine supports (e.g. home/resourcesful/errors)
      # @see https://github.com/reinteractive/wallaby/blob/master/config/routes.rb config/routes.rb
      # @param context [ActionController::Base, ActionView::Base]
      # @param options [Hash, ActionController::Parameters]
      # @return [String] path string for wallaby engine
      # @return [nil] nil if given engine name cannot be found
      def handle(context:, options:)
        return unless options.is_a?(Hash) || options.try(:permitted?)

        engine = context.try(options.delete(:engine_name) || context.try(:current_engine_name))
        options = context.with_query(options, url_options: context.url_options).symbolize_keys

        engine.try action_path_from(options), options if options[:resources] || action_path_from(options).present?
      end

      protected

      # Find out the named path from given params
      # @return [Symbol] named path
      def action_path_from(params)
        action = params[:action] || params.fetch(:_recall, {})[:action]
        ACTION_TO_PATH_MAP[action]
      end
    end
  end
end
