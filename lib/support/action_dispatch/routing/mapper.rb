# frozen_string_literal: true

module ActionDispatch
  module Routing
    # Re-open `ActionDispatch::Routing::Mapper` to add route helpers for Wallaby.
    class Mapper
      # Mount {Wallaby::Engine} to given mount path.
      # And prepend custom routes to {Wallaby::Engine} if block is given.
      # @example Mount {Wallaby::Engine} to a path
      #   wallaby_mount at: '/admin'
      # @example Mount and prepend custom routes to {Wallaby::Engine}
      #   wallaby_mount at: '/super_admin' do
      #     resource :account
      #   end
      # @param at [String]
      # @param options [Hash]
      def wallaby_mount(at:, **options, &block)
        Wallaby::Engine.routes.draw(&block) if block_given?
        mount Wallaby::Engine, at: at, **options
      end

      # @deprecated
      def wresources(*resource_names, &block)
        Wallaby::Deprecator.alert method(__callee__), from: '0.3.0', alternative: <<~INSTRUCTION
          Please use `resources` instead and include `Wallaby::ResourcesConcern` in the controller. For example:

            # config/routes.rb
            resources :blogs

            # app/controllers/blogs_controller.rb
            class BlogsController < ApplicationController
              include Wallaby::ResourcesConcern
            end
        INSTRUCTION
      end

      # @deprecated
      def wresource(*resource_names, &block)
        Wallaby::Deprecator.alert method(__callee__), from: '0.3.0', alternative: <<~INSTRUCTION
          Please use `resource` instead and include `Wallaby::ResourcesConcern` in the controller. For example:

            # config/routes.rb
            resource :profile

            # app/controllers/profiles_controller.rb
            class ProfilesController < ApplicationController
              include Wallaby::ResourcesConcern
            end
        INSTRUCTION
      end
    end
  end
end
