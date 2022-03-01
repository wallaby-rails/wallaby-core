# frozen_string_literal: true

module Wallaby
  # Resources related attributes & helper methods
  module Resourcable
    # @return [String] resources name for current request
    def current_resources_name
      @current_resources_name ||= params[:resources]
    end

    # Model class for current request.
    #
    # It comes from two places:
    #
    # - configured {Baseable::ClassMethods#model_class .model_class}
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
    # To allowlist the request params for {ResourcesConcern#create} and {ResourcesConcern#update} actions.
    #
    # It can be replaced completely in subclasses:
    #
    #     def resource_params
    #       params.fetch(:product, {}).permit(:name, :sku)
    #     end
    # @return [ActionController::Parameters] allowlisted params
    def resource_params
      @resource_params ||= current_servicer.permit params, action_name
    end

    # @note This is a template method that can be overridden by subclasses.
    # To allowlist the request params for {ResourcesConcern#create create} action.
    #
    # It can be replaced completely in subclasses:
    #
    #     def create_params
    #       params.fetch(:product, {}).permit(:name, :sku)
    #     end
    # @return [ActionController::Parameters] allowlisted params
    def create_params
      @create_params ||= resource_params
    end

    # @note This is a template method that can be overridden by subclasses.
    # To allowlist the request params for {ResourcesConcern#update update} action.
    #
    # It can be replaced completely in subclasses:
    #
    #     def update_params
    #       params.fetch(:product, {}).permit(:name, :sku)
    #     end
    # @return [ActionController::Parameters] allowlisted params
    def update_params
      @update_params ||= resource_params
    end

    # @note This is a template method that can be overridden by subclasses.
    # This is a method to return collection for {ResourcesConcern#index index} action and page.
    #
    # It can be customized as below in subclasses:
    #
    #     def collection
    #       # do something before the original action
    #       options = {} # @see arguments for more details
    #       # NOTE: this is better than using `super` in many ways, but choose the one that better fits your scenario
    #       collection!(options) do |query|
    #         # NOTE: make sure a collection is returned
    #         query.where(active: true)
    #       end
    #     end
    #
    # Otherwise, it can be replaced completely in subclasses:
    #
    #     def collection
    #       # NOTE: pagination should happen here if needed
    #       # NOTE: make sure `@collection` and conditional assignment (the OR EQUAL) operator is used
    #       @collection ||= paginate Product.active
    #     end
    # @param params [Hash, ActionController::Parameters] parameters for collection query, default to request parameters
    # @param paginate [Boolean] see {Paginatable#paginate}
    # @param paginate_options [Hash] options accepted by {Paginatable#paginate} (since 0.3.0)
    # @yield [collection] (since wallaby-5.2.0) a block to run to extend/convert the original collection,
    #   e.g. call chain with more queries
    # @return [#each] a collection of records
    def collection(params: self.params, paginate: true, **paginate_options, &block)
      @collection ||=
        ModuleUtils.yield_for(
          paginate(
            current_servicer.collection(params),
            ({ paginate: paginate }).merge(paginate_options)
          ),
          &block
        )
    end
    alias collection! collection

    # @note This is a template method that can be overridden by subclasses.
    # This is a method to return resource for pages except `index`.
    #
    # It can be customized as below in subclasses:
    #
    #     def resource
    #       # do something before the original action
    #       # NOTE: this is better than using `super` in many ways, but choose the one that better fits your scenario
    #       resource! do |object|
    #         object.preload_status_from_api
    #         # NOTE: make sure correct object is returned
    #         object
    #       end
    #     end
    #
    # Otherwise, it can be replaced completely in subclasses:
    #
    #     def resource
    #       # NOTE: make sure `@resource` and conditional assignment (the OR EQUAL) operator is used
    #       @resource ||= resource_id.present? ? Product.find_by_slug(resource_id) : Product.new(arrival: true)
    #     end
    # @yield [resource] (since wallaby-5.2.0) a block to run to extend resource, e.g. making change to the resource.
    #   Please make sure to return the expected resource at the end of block
    # @return [Object] either persisted or unpersisted resource instance
    # @raise [ResourceNotFound] if resource is not found
    def resource(&block)
      @resource ||=
        ModuleUtils.yield_for(
          resource_id.present? && current_servicer.find(resource_id) || new_resource,
          &block
        )
    end
    alias resource! resource

    # @note This is a template method that can be overridden by subclasses.
    # This is the
    #
    # It can be customized as below in subclasses:
    #
    #     def new_resource
    #       # do something before the original action
    #       # NOTE: this is better than using `super` in many ways, but choose the one that better fits your scenario
    #       new_resource! do |object|
    #         object.preload_status_from_api
    #         # NOTE: make sure expected object is returned
    #         object
    #       end
    #     end
    #
    # Otherwise, it can be replaced completely in subclasses:
    #
    #     def new_resource
    #       # NOTE: make sure `@resource` and conditional assignment (the OR EQUAL) operator is used
    #       @resource ||= Product.new(arrival: true)
    #     end
    # @yield [resource] (since wallaby-5.2.0) a block to run to extend resource, e.g. making change to the resource.
    #   Please make sure to return the expected resource at the end of block
    # @return [Object] either persisted or unpersisted resource instance
    # @raise [ResourceNotFound] if resource is not found
    # @since 0.3.0
    def new_resource(&block)
      @resource ||= # rubocop:disable Naming/MemoizedInstanceVariableName
        ModuleUtils.yield_for(current_servicer.new, &block)
    end
    alias new_resource! new_resource
  end
end
