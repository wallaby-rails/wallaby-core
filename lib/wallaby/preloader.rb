# frozen_string_literal: true

module Wallaby
  # Preload files for eager load paths.
  #
  # As Wallaby is built upon the {Wallaby::Map} which will not be completed
  # until all models and decorators/controllers/servicers/authorizers/paginators
  # are loaded. Therefore, when Rails app is initialized,
  # all files under eager load paths (mostly `app/*` folders),
  # especially the files under `app/models`, need to be loaded before everything else.
  class Preloader
    include ActiveModel::Model

    # Require all files
    # @see #all_file_paths
    def self.require_all
      new.all_file_paths.each(&method(:require_dependency))
    end

    # Require models under {Wallaby::Configuration#model_paths}
    # @see #model_file_paths
    def self.require_models
      new.model_file_paths.each(&method(:require_dependency))
    end

    # @return [Array<String>] all files under **Rails.configuration.eager_load_paths**
    def all_file_paths
      sort all_eager_load_file_paths
    end

    # @return [Array<String>] model files under {Wallaby::Configuration#model_paths}
    def model_file_paths
      sort(all_eager_load_file_paths).select(&method(:indexed))
    end

    # @!attribute [w] eager_load_paths
    attr_writer :eager_load_paths

    # @!attribute [r] eager_load_paths
    # @return [Array<String, Pathname>]
    def eager_load_paths # :nodoc:
      @eager_load_paths ||=
        Rails.configuration.paths['app'].expanded
          .concat(Rails.configuration.eager_load_paths)
          .uniq
    end

    # @!attribute [w] model_paths
    attr_writer :model_paths

    # @!attribute [r] model_paths
    # @return [Array<String>]
    def model_paths # :nodoc:
      @model_paths ||= Wallaby.configuration.model_paths
    end

    private

    def all_eager_load_file_paths # :nodoc:
      Dir.glob(eager_load_paths.map { |load_path| "#{load_path}/**/*.rb" })
    end

    # All files need to be sorted in the following orders:
    # 1. {Wallaby::Configuration#model_paths} order
    # 2. Alphabet order
    def sort(file_paths)
      file_paths.sort { |p1, p2| conditions_for(p1) <=> conditions_for(p2) }
    end

    # @see #sort
    def conditions_for(path)
      [indexed(path) || model_paths.length, path]
    end

    # Check if the path is in the {Wallaby::Configuration#model_paths}
    def indexed(path)
      model_paths.index(&path.method(:include?))
    end
  end
end
