# frozen_string_literal: true

module Wallaby
  # Resources related attributes
  module Resourcable
    # @return [String] resources name for current request
    def current_resources_name
      @current_resources_name ||= params[:resources]
    end

    # Model class for current request. It comes from two places:
    #
    # - {Configurable#wallaby_controller}'s **model_class**
    # - fall back to the model class converted from either the {#current_resources_name}
    #   or **controller_path**
    # @return [Class] model class for current request
    def current_model_class
      @current_model_class ||=
        wallaby_controller.model_class || Map.model_class_map(current_resources_name || controller_path)
    end

    # Shorthand of params[:id]
    # @return [String, nil] ID param
    def resource_id
      params[:id]
    end

    # @note This is a template method that can be overridden by subclasses.
    # To whitelist the params for {ResourcesConcern#create} and {ResourcesConcern#update} actions.
    #
    # If Wallaby cannot generate the correct strong parameters, it can be replaced, for example:
    #
    #     def resource_params
    #       params.fetch(:product, {}).permit(:name, :sku)
    #     end
    # @return [ActionController::Parameters] whitelisted params
    def resource_params
      @resource_params ||= current_servicer.permit params, action_name
    end

    def create_params
      resource_params
    end

    def update_params
      resource_params
    end

    # @note This is a template method that can be overridden by subclasses.
    # This is a method to return collection for index page.
    #
    # It can be customized as below in subclasses:
    #
    #     def collection
    #       # do something before the original action
    #       options = {} # NOTE: see `options` parameter for more details
    #       collection! options do |query| # NOTE: this is better than using `super`
    #         # NOTE: make sure a collection is returned
    #         query.where(active: true)
    #       end
    #     end
    #
    # Otherwise, it can be replaced completely in subclasses:
    #
    #     def collection
    #       # NOTE: pagination should happen here if needed
    #       # NOTE: make sure `@collection` and conditional assignment (the OR EQUAL) operator are used
    #       @collection ||= paginate Product.active
    #     end
    # @param options [Hash] (since wallaby-5.2.0)
    # @option options [Hash, ActionController::Parameters] :params parameters for collection query
    # @option options [Boolean] :paginate see {Paginatable#paginate}
    # @yield [collection] (since wallaby-5.2.0) a block to run to extend collection, e.g. call chain with more queries
    # @return [#each] a collection of records
    def collection(params: self.params, paginate: true, **options, &block)
      @collection ||=
        ModuleUtils.yield_for(
          paginate(current_servicer.collection(params), ({ paginate: paginate }).merge(options)),
          &block
        )
    end
    alias collection! collection

    # @note This is a template method that can be overridden by subclasses.
    # This is a method to return resource for pages except `index`.
    #
    # `WARN: It does not do mass assignment since wallaby-5.2.0.`
    #
    # It can be customized as below in subclasses:
    #
    #     def resource
    #       # do something before the original action
    #       options = {} # NOTE: see `options` parameter for more details
    #       resource! options do |object| # NOTE: this is better than using `super`
    #         object.preload_status_from_api
    #         # NOTE: make sure object is returned
    #         object
    #       end
    #     end
    #
    # Otherwise, it can be replaced completely in subclasses:
    #
    #     def resource
    #       # NOTE: make sure `@resource` and conditional assignment (the OR EQUAL) operator are used
    #       @resource ||= resource_id.present? ? Product.find_by_slug(resource_id) : Product.new(arrival: true)
    #     end
    # @yield [resource] (since wallaby-5.2.0) a block to run to extend resource, e.g. making change to the resource.
    #   Please make sure to return the resource at the end of block
    # @return [Object] either persisted or unpersisted resource instance
    # @raise [ResourceNotFound] if resource is not found
    def resource(&block)
      @resource ||=
        ModuleUtils.yield_for(
          if resource_id.present?
            current_servicer.find resource_id
          end,
          &block
        )
      @resource || new_resource(&block)
    end
    alias resource! resource

    def new_resource(&block)
      @resource ||=
        ModuleUtils.yield_for(current_servicer.new, &block)
    end
    alias new_resource! new_resource
  end
end
