# frozen_string_literal: true

module Wallaby
  # This is the core of {Wallaby} as it dynamically dispatches request to appropriate controller and action.
  #
  # Assume that {Wallaby} is mounted at `/admin` and the resources name is `order::items`,
  # it will try to find out which controller to dispatch to by:
  #
  # 1. check if the controller name `Admin::Order::ItemsController` exists
  #   (converted from the mount path and resources name)
  # 2. check if the `params[:resources_controller]` is set
  # 3. fall back to default resources controller
  #   (`Admin::ApplicationController` or {Wallaby::ResourcesController}) from
  #   {Wallaby::Configuration#resources_controller Wallaby.configuration.resources_controller}
  # @see http://edgeguides.rubyonrails.org/routing.html#routing-to-rack-applications
  class ResourcesRouter
    RESOURCESFUL_ACTIONS = %i(index new create show edit update destroy).freeze
    # It tries to find out the controller that has the same model class from converted resources name.
    # Otherwise, it falls back to base resources controller which will come from the following sources:
    #
    # 1. `:resources_controller` parameter
    # 2. resources_controller mapping configuration,
    #   e.g. `Admin::ApplicationController` if defined or `Wallaby::ResourcesController`
    # @param env [Hash] see https://github.com/rack/rack/blob/master/SPEC.rdoc
    def call(env)
      params = env[ActionDispatch::Http::Parameters::PARAMETERS_KEY]
      validate_model_by params[:resources]
      # byebug
      controller = find_controller_by(script_name: env[SCRIPT_NAME], params: params)
      controller.action(params[:action]).call(env)
    rescue ::AbstractController::ActionNotFound, ModelNotFound => e
      set_message_for(e, env)
      default_controller(params).action(:not_found).call(env)
    rescue UnprocessableEntity => e
      set_message_for(e, env)
      default_controller(params).action(:unprocessable_entity).call(env)
    end

    private

    # Find controller class
    # @param script_name [String]
    # @param params [Hash]
    # @return [Class] controller class
    def find_controller_by(script_name:, params:)
      klass = Inflector.classify("#{script_name}/#{params[:resources]}_Controller")
      klass.constantize
    rescue NameError
      Logger.hint <<~INSTRUCTION
        HINT: To customize the controller for `#{params[:resources]}`, create the following controller:

          class #{klass} < #{default_controller(params)}
            def #{params[:action]}
              # customization starts here
            end
          end
      INSTRUCTION

      default_controller(params)
    end

    # @param params [Hash]
    # @return [Class] default controller class
    def default_controller(params)
      params[:resources_controller] || Wallaby.configuration.resources_controller
    end

    # Validate the model class
    # @param params [Hash]
    # @return [Class]
    # @raise [Wallaby::ModelNotFound] when model class is not found
    # @raise [Wallaby::UnprocessableEntity] when there is no corresponding mode found for model class
    def validate_model_by(resources_name)
      return unless resources_name

      model_class = ModelUtils.to_model_class(resources_name)
      raise ModelNotFound, resources_name unless model_class

      unless Map.mode_map[model_class]
        raise UnprocessableEntity, Locale.t('errors.unprocessable_entity.model', model: model_class)
      end
    end

    # Set flash error message
    # @param exception [Exception]
    # @param env [Hash] @see http://www.rubydoc.info/github/rack/rack/master/file/SPEC
    def set_message_for(exception, env)
      session = env[ActionDispatch::Request::Session::ENV_SESSION_KEY] || {}
      env[ActionDispatch::Flash::KEY] ||= ActionDispatch::Flash::FlashHash.from_session_value session['flash']
      flash = env[ActionDispatch::Flash::KEY]
      flash[:alert] = exception.message
    end
  end
end
