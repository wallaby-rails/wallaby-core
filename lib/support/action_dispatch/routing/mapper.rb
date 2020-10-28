# frozen_string_literal: true

module ActionDispatch
  module Routing
    # Re-open `ActionDispatch::Routing::Mapper` to add route helpers for Wallaby.
    class Mapper
      # Mount {Wallaby::Engine} to given path.
      # And prepend custom routes to Rails app if block is given.
      # @example Mount {Wallaby::Engine} to a path
      #   wallaby_mount at: '/admin'
      # @example Mount {Wallaby::Engine} and prepend custom routes
      #   wallaby_mount at: '/super_admin' do
      #     resource :accounts
      #   end
      #   # the above is basically the same as:
      #   namespace :admin do
      #     resource :accounts
      #   end
      #   mount Wallaby::Engine, at: '/admin'
      # @param options [Hash]
      # @option options [String] :at the path to mount {Wallaby::Engine} to
      # @option options [Symbol, String] :as  engine alias name
      # @option options [Array] :via HTTP methods
      def wallaby_mount(options, &block)
        namespace(options[:at][1..-1] || '', options.except(:at), &block) if block_given?
        mount Wallaby::Engine, options.slice(:at, :as, :via)
      end

      # @deprecated
      def wresources(*_resource_names)
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
      def wresource(*_resource_names)
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
