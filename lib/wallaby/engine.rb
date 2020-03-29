# frozen_string_literal: true

module Wallaby
  # Wallaby engine
  class Engine < ::Rails::Engine
    initializer 'wallaby.development.reload' do |_|
      # NOTE: Rails reload! will hit here
      # @see http://rmosolgo.github.io/blog/2017/04/12/watching-files-during-rails-development/
      config.to_prepare do
        if Rails.env.development? || Rails.configuration.eager_load
          ::Wallaby::Logger.debug 'Reloading...', sourcing: false
          ::Wallaby::Map.clear
          ::Wallaby::Preloader.require_all
        end
      end
    end

    config.before_eager_load do
      # NOTE: We need to ensure that the core models are loaded before everything else
      ::Wallaby::Logger.debug 'Preload all model files.', sourcing: false
      ::Wallaby::Preloader.require_models
    end

    config.after_initialize do
      # Load the rest files
      unless Rails.env.development? || Rails.configuration.eager_load
        ::Wallaby::Logger.debug 'Preload files after initialize.', sourcing: false
        ::Wallaby::Preloader.require_all
      end
    end
  end
end
