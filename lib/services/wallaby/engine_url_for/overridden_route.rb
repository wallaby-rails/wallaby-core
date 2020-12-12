# frozen_string_literal: true

module Wallaby
  class EngineUrlFor
    # The general route of {Engine} looks like as follow:
    #
    #     /admin/order::items
    #
    # Therefore, to override this route, dev needs to define a resources as below
    # before mounting {Engine}:
    #
    #     namespace :admin do
    #       # NOTE: in order for the route to work properly,
    #       # the colon before words need to be escaped in the path option
    #       resources :items, path: 'order:\:item', module: :order
    #     end
    #     wallaby_mount at: '/admin'
    #
    # So to find out if any route has been overriden with current request, e.g. `/admin/order::items/1/edit`,
    # we will look into the following conditions:
    #
    # - begins with `/admin/order::items`
    # - same **action** as the given **action**
    # - default **controller** exists (as {ResourcesRouter} does not define static **controller**)
    #
    # Then we use this route's params and pass it to the origin `url_for`.
    class OverriddenRoute
      include ActiveModel::Model

      delegate :defaults, to: :route

      # @!attribute script_name
      # @return [String]
      attr_accessor :script_name
      # @!attribute model_class
      # @return [Class]
      attr_accessor :model_class
      # @!attribute action_name
      # @return [String]
      attr_accessor :action_name
      # @!attribute resources_name
      # @return [String]
      attr_accessor :resources_name

      # @return [true] if model is given and defined application route is found.
      # @return [false] otherwise
      def exist?
        model_class.present? && route.present?
      end

      # @return [String] the URL for this application route
      def url_for(params)
        Rails.application.routes.url_for(params)
      end

      protected

      # @return [ActionDispatch::Journey::Route]
      #   the application route that overrides the route handled by {Engine}
      def route
        @route ||= Rails.application.routes.routes.find do |route|
          prefix_matched?(route) && same_action?(route) && controller_exist?(route)
        end
      end

      # @return [true] if route's path begins with the prefix as where {Engine} route to,
      #   e.g. `/admin/order::items`
      # @return [false] otherwise
      def prefix_matched?(route)
        route.path.spec.to_s =~ prefix_regex
      end

      # @return [true] if route's action is the same as the given action
      # @return [false] otherwise
      def same_action?(route)
        route.defaults[:action] == action_name
      end

      # @return [true] if route's controller is defined
      # @return [false] otherwise
      def controller_exist?(route)
        route.defaults[:controller].present?
      end

      # @return [Regexp]
      def prefix_regex
        @prefix_regex ||= %r{\A#{prefix}(\Z|/)}
      end

      # @return [String] the prefix, e.g. `/admin/order::items`
      def prefix
        [script_name, resources_name].map(&:presence).compact.join(SLASH)
      end
    end
  end
end
