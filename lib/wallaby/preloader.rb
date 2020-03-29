# frozen_string_literal: true

module Wallaby
  # Preload utils
  module Preloader
    class << self
      # Require all eager load paths
      def require_all
        sorted_eager_load_paths.each(&method(:load_dependencies_for))
      end

      # Require models defined in {.model_paths}
      def require_models
        sorted_eager_load_paths.grep(model_paths).each(&method(:load_dependencies_for))
      end

      protected

      # @return [Array<String, Pathname>] a list of sorted eager load paths by given order
      def sorted_eager_load_paths
        Rails.configuration.eager_load_paths.sort_by do |path|
          - path.to_s.index(model_paths).to_i
        end
      end

      # Delegate to {Wallaby::Configuration#model_paths}
      def model_paths
        Wallaby.configuration.model_paths
      end

      # require_dependency each file of given folder
      # @param folder [String, Path]
      def load_dependencies_for(folder)
        Dir.glob("#{folder}/**/*.rb").sort.each(&method(:load_each_dependency_of))
      end

      # require_dependency given file path
      # @param file_path [String, Path]
      def load_each_dependency_of(file_path)
        require_dependency file_path
      rescue NameError, LoadError => e
        Logger.debug "Preload warning: #{e.message} for #{file_path}"
      end
    end
  end
end
