# frozen_string_literal: true

module Wallaby
  # Wallaby engine
  class Engine < ::Rails::Engine
    initializer 'wallaby.development.reload' do |_|
      # NOTE: Rails reload! will hit here
      # @see http://rmosolgo.github.io/blog/2017/04/12/watching-files-during-rails-development/
      config.to_prepare do
        if Rails.env.development? || Rails.configuration.eager_load
          Logger.debug 'Reloading after Rails\' reload...', sourcing: false
          Map.clear
          Preloader.require_all
        end
      end
    end

    config.before_eager_load do
      # NOTE: The models must be loaded before everything else
      Logger.debug 'Preload all `app/models` files.', sourcing: false
      Preloader.require_models
    end

    config.after_initialize do
      # Load the rest files
      unless Rails.env.development? || Rails.configuration.eager_load
        Logger.debug 'Preload all other eager load files after initialize.', sourcing: false
        Preloader.require_all
      end
    end
  end
end
