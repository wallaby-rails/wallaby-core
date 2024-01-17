# frozen_string_literal: true

module Wallaby
  # Wallaby engine
  class Engine < ::Rails::Engine
    initializer 'wallaby.development.reload' do |_|
      # NOTE: Rails reload! will hit here
      # @see https://rmosolgo.github.io/ruby/rails/2017/04/12/watching-files-during-rails-development.html
      config.to_prepare do
        Map.clear
        Preloader.clear
      end
    end

    config.before_eager_load do
      Logger.debug 'Preload all model files before everything else.', sourcing: false
      Preloader.require_models
    end

    config.after_initialize do
      # Preload will be postponed to Map when `cache_classes` is set to false
      next unless Rails.configuration.cache_classes
      # Models are preloaded in `before_eager_load` block,
      # therefore, it's not essential to preload all files Since Rails will do it
      next if Rails.configuration.eager_load

      Logger.debug 'Preload all files in model first and non-model last order', sourcing: false
      Preloader.require_all
    end
  end
end
