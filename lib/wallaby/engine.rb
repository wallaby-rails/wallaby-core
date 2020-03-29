# frozen_string_literal: true

module Wallaby
  # Wallaby engine
  class Engine < ::Rails::Engine
    # class << self
    #   # Require all eager load paths
    #   def require_all
    #     sorted_eager_load_paths.each(&method(:load_dependency))
    #   end

    #   # Require given eager load path(s)
    #   # @param path [String, Regex]
    #   def require_folder(path)
    #     sorted_eager_load_paths.grep(path).each(&method(:load_dependency))
    #   end

    #   protected

    #   # @param top_priorities [String, Regexp]
    #   # @return [Array<String, Pathname>] a list of sorted eager load paths by given order
    #   def sorted_eager_load_paths(top_priorities = %r{app/models})
    #     Rails.configuration.eager_load_paths.sort_by do |path|
    #       - path.to_s.index(top_priorities).to_i
    #     end
    #   end

    #   def load_dependency(folder)
    #     Dir.glob("#{folder}/**/*.rb").sort.each do |file_path|
    #       begin
    #         Logger.debug "Loading #{file_path}"
    #         require_dependency file_path
    #       rescue NameError, LoadError => e
    #         Logger.debug "Preload warning: #{e.message} from #{file_path}"
    #         Logger.debug e.backtrace.slice(0, 5)
    #       end
    #     end
    #   end
    # end

    initializer 'wallaby.development.reload' do |_|
      # NOTE: Rails reload! will hit here
      # @see http://rmosolgo.github.io/blog/2017/04/12/watching-files-during-rails-development/
      config.to_prepare do
        if Rails.env.development? || Rails.configuration.eager_load
          Logger.debug 'Reloading...', sourcing: false
          ::Wallaby::Map.clear
          Dependency.require_all
        end
      end
    end

    config.before_eager_load do
      # NOTE: We need to ensure that the core models are loaded before anything else
      Logger.debug 'Preload all model files.', sourcing: false
      Dependency.require_models
    end

    # Preload the rest files
    config.after_initialize do
      unless Rails.env.development? || Rails.configuration.eager_load
        Logger.debug 'Preload files after initialize.', sourcing: false
        Dependency.require_all
      end
    end
  end
end
