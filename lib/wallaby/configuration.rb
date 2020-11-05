# frozen_string_literal: true

# Wallaby
module Wallaby
  # Global configuration
  class Configuration
    include Classifier

    # @!attribute [w] logger
    attr_writer :logger

    # @!attribute [r] logger
    def logger
      @logger ||= Rails.logger
    end

    # @!attribute [w] model_paths
    def model_paths=(*model_paths)
      @model_paths =
        model_paths.flatten.compact.presence.try do |paths|
          next paths if paths.all? { |p| p.is_a?(String) }

          raise ArgumentError, 'Please provide a list of string paths, e.g. `["app/models", "app/core"]`'
        end
    end

    # @!attribute [r] model_paths
    # To configure the model folders that {Wallaby::Preloader} needs to load before everything else.
    # Default is `%w(app/models)`
    # @example To set the model paths
    #   Wallaby.config do |config|
    #     config.model_paths = ["app/models", "app/core"]
    #   end
    # @return [Array<String>] model paths
    # @since 0.2.2
    def model_paths
      @model_paths ||= %w(app/models)
    end

    # @!attribute [w] base_controller
    def base_controller=(base_controller)
      @base_controller = class_name_of base_controller
    end

    # @!attribute [r] base_controller
    # To globally configure the base controller class that {Wallaby::ResourcesController} should inherit from.
    #
    # If no configuration is given, {Wallaby::ResourcesController} defaults to inherit from **::ApplicationController**
    # from the host Rails app.
    # @example To update base controller to `CoreController` in `config/initializers/wallaby.rb`
    #   Wallaby.config do |config|
    #     config.base_controller = ::CoreController
    #   end
    # @return [Class] base controller class
    def base_controller
      to_class @base_controller ||= '::ApplicationController'
    end

    # @!attribute [w] resources_controller
    def resources_controller=(resources_controller)
      @resources_controller = class_name_of resources_controller
    end

    # @!attribute [r] resources_controller
    # To globally configure the application controller class that {Wallaby::Engine} should use.
    #
    # If no configuration is given, {Wallaby::Engine} defaults to use **Admin::ApplicationController** or
    # {Wallaby::ResourcesController}
    # from the host Rails app.
    # @example To update base controller to `CoreController` in `config/initializers/wallaby.rb`
    #   Wallaby.config do |config|
    #     config.resources_controller = ::CoreController
    #   end
    # @return [Class] base controller class
    # @since 0.2.3
    def resources_controller
      @resources_controller ||=
        defined?(::Admin::ApplicationController) \
          && ::Admin::ApplicationController < ::Wallaby::ResourcesController \
          && 'Admin::ApplicationController'
      to_class @resources_controller ||= 'Wallaby::ResourcesController'
    end

    # @return [Wallaby::Configuration::Models] models configuration for custom mode
    def custom_models
      @custom_models ||= ClassArray.new
    end

    # To globally configure the models for custom mode.
    # @example To update the model classes in `config/initializers/wallaby.rb`
    #   Wallaby.config do |config|
    #     config.custom_models = [Product, Order]
    #   end
    # @param models [Array<[Class, String]>] a list of model classes/name strings
    def custom_models=(models)
      @custom_models = ClassArray.new models.flatten
    end

    # @return [Wallaby::Configuration::Models] models configuration
    def models
      @models ||= Models.new
    end

    # To globally configure the models that Wallaby should handle.
    # @example To update the model classes in `config/initializers/wallaby.rb`
    #   Wallaby.config do |config|
    #     config.models = [Product, Order]
    #   end
    # @param models [Array<[Class, String]>] a list of model classes/name strings
    def models=(models)
      self.models.set models
    end

    # @return [Wallaby::Configuration::Security] security configuration
    def security
      @security ||= Security.new
    end

    # @return [Wallaby::Configuration::Mapping] mapping configuration
    def mapping
      @mapping ||= Mapping.new
    end

    # @return [Wallaby::Configuration::Metadata] metadata configuration
    def metadata
      @metadata ||= Metadata.new
    end

    # @return [Wallaby::Configuration::Pagination] pagination configuration
    def pagination
      @pagination ||= Pagination.new
    end

    # @return [Wallaby::Configuration::Features] features configuration
    def features
      @features ||= Features.new
    end

    # @return [Wallaby::Configuration::Sorting] sorting configuration
    def sorting
      @sorting ||= Sorting.new
    end

    # Clear all configurations
    def clear
      instance_variables.each { |name| instance_variable_set name, nil }
    end
  end

  # @return [Wallaby::Configuration]
  def self.configuration
    @configuration ||= Configuration.new
  end

  # To config settings using a block
  # @example
  #   Wallaby.config do |c|
  #     c.pagination.page_size = 20
  #   end
  def self.config
    yield configuration
  end

  def self.controller_configuration
    RequestStore.store[:wallaby_controller].tap do |config|
      raise ArgumentError, <<~INSTRUCTION if config.nil?
        Please make sure to set `before_action :set_controller_configuration` in the controller, for example:

          class Admin::ApplicationController < Wallaby::ResourcesController
            before_action :set_controller_configuration
          end
      INSTRUCTION
    end
  end
end
