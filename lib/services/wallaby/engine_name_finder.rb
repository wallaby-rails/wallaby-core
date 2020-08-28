# frozen_string_literal: true

module Wallaby
  # Service object to find the engine name by given request environment variables.
  class EngineNameFinder
    class << self
      # Loop through all the routes and find out which one matches the given request path.
      #
      # When it can't find the engine name, it will return empty string
      # to prevent it from being run again.
      # @param env [String] request path
      # @return [String] engine name if found
      # @return [String] empty string if not found
      def find(request_path)
        named_route = Rails.application.routes.routes.find do |route|
          route.path.match(request_path) && route.app.app == Wallaby::Engine
        end
        named_route.try(:name) || EMPTY_STRING
      end
    end
  end
end
