# frozen_string_literal: true

module Wallaby
  class EngineUrlFor
    # The other routes defined under the same prefix as {Engine}'s mount path should look like this:
    #
    # ```
    # resources :custom_categories, path: '/admin/custom_categories'
    # ```
    #
    # Here, `custom_categories` is not a resources name handled by {Engine}.
    #
    # In this case, we will need to check if any route that meets the following conditions has been defined:
    #
    # - begins with **script_name/controller_path**, e.g. `/admin/custom_categories`
    # - same **controller_path** as the given **controller_path**
    # - same **action** as the given **action**
    class OtherRoute
      include ActiveModel::Model

      delegate :defaults, to: :route

      # @!attribute script_name
      # @return [String]
      attr_accessor :script_name
      # @!attribute model_class
      # @return [Class]
      attr_accessor :model_class
      # @!attribute current_model_class
      # @return [Class]
      attr_accessor :current_model_class
      # @!attribute controller_path
      # @return [String]
      attr_accessor :controller_path
      # @!attribute action_name
      # @return [String]
      attr_accessor :action_name

      # @return [true] if current model is the same as given model
      #   and defined application route is found.
      # @return [false] otherwise
      def exist?
        model_class == current_model_class && route.present?
      end

      # @return [String] the URL for this application route
      def url_for(params)
        Rails.application.routes.url_for(params)
      end

      protected

      # @return [ActionDispatch::Journey::Route]
      #   the application route that under the same mount path as {Engine}
      def route
        @route ||= Rails.application.routes.routes.find do |route|
          prefix_matched?(route) && same_controller_and_action?(route)
        end
      end

      # @return [true] if route's path begins with the prefix as where {Engine} is mounted to, e.g. `/admin`
      # @return [false] otherwise
      def prefix_matched?(route)
        route.path.spec.to_s =~ prefix_regex
      end

      # @return [true] if route's controller and action are the same as the given controller and action
      # @return [false] otherwise
      def same_controller_and_action?(route)
        route.defaults[:controller] == controller_path && route.defaults[:action] == action_name
      end

      # @return [Regexp]
      def prefix_regex
        @prefix_regex ||= %r{\A#{prefix}(\Z|/)}
      end

      # @return [String] the prefix, e.g. `/admin/custom_categories`
      #   when current controller path is `custom_categories`
      def prefix
        [script_name, controller_path].map(&:presence).compact.join(SLASH)
      end
    end
  end
end
