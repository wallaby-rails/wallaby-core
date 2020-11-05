# frozen_string_literal: true

module Wallaby
  # Find out the engine routing proxy name
  class EngineNameFinder
    class << self
      # Loop through all the routes and find out the engine routing proxy name
      # for the given request path.
      #
      # When it can't find the engine name, it will return empty string
      # to prevent it from being run again.
      # @param request_path [String] request path
      # @return [String] engine name if found
      # @return [String] empty string "" if not found
      def execute(request_path)
        named_routes =
          Rails.application.routes.routes.select { |route| route.path.match(request_path) }
        return EMPTY_STRING unless named_routes.length == 1 && named_routes.first.app.app == Wallaby::Engine

        named_routes.first.try(:name)
      end
    end
  end
end
