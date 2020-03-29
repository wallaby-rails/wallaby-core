# frozen_string_literal: true

module Wallaby
  # Preload utils
  module Dependency
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

      # @return [Array<String, Pathname>] a list of sorted eager load paths which lists `app/models`
      #   at highest precedence
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
        Dir.glob("#{folder}/**/*.rb").sort.each do |file_path|
          begin
            require_dependency file_path
          rescue NameError, LoadError => e
            Logger.debug "Preload warning: #{e.message} from #{file_path}"
            Logger.debug e.backtrace.slice(0, 5)
          end
        end
      end
    end
  end
end
