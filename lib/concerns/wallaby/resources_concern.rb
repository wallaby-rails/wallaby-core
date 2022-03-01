# frozen_string_literal: true

module Wallaby
  # Resources concern defining the controller behaviors
  # for {ResourcesController} and other controllers that include itself
  module ResourcesConcern
    extend ActiveSupport::Concern

    include Authorizable
    include Baseable
    include Configurable
    include Decoratable
    include Prefixable
    include Paginatable
    include Resourcable
    include Servicable

    included do
      include View
      alias_method :_prefixes, :wallaby_prefixes

      include ApplicationConcern
      include AuthenticationConcern

      base_class! if self == ResourcesController

      # NOTE: to ensure Wallaby's layout
      # is not inheriting from/impacted by parent controller's layout.
      if respond_to?(:layout)
        try(
          # inherit? or include?
          self == ResourcesController ? :layout : :theme_name=,
          ResourcesController.controller_path
        )
      end

      self.responder = ResourcesResponder
      respond_to :html
      respond_to :json
      respond_to :csv
      try :helper, ResourcesHelper
      before_action :authenticate_wallaby_user!
    end

    # @note This is a template method that can be overridden by subclasses.
    # This is an action for landing page display. It does nothing more than rendering `home` template.
    #
    # It can be replaced completely in subclasses as below:
    #
    #     def home
    #       generate_dashboard_report
    #     end
    def home
      # do nothing
    end

    # @note This is a template method that can be overridden by subclasses.
    # This is a resourcesful action to list records that user can access.
    #
    # It can be customized as below in subclasses:
    #
    # `WARN: Please keep in mind that Wallaby User Interface requires **index**
    # action to respond to **csv** and **json** format as well.`
    #
    #     def index
    #       # do something before the original action
    #       responder_options = {} # NOTE: see `responder_options` parameter for more details
    #       # NOTE: this is better than using `super` in many ways, but choose the one that better fits your scenario
    #       index!(responder_options) do |format|
    #         # NOTE: this block is for `respond_with` which works similar to `respond_to`
    #         # customize response behaviour, or do something before the request is rendered
    #       end
    #     end
    #
    # Otherwise, it can be replaced completely in subclasses:
    #
    # `WARN: Please keep in mind that Wallaby User Interface requires **index**
    # action to respond to **csv** and **json** format as well.`
    #
    #     def index
    #       # NOTE: `@collection` will be used by the view, please ensure it is assigned, for example:
    #       @collection = Product.all
    #       respond_with @collection
    #     end
    # @param responder_options [Hash] (since wallaby-5.2.0) responder_options for
    #   {https://www.rubydoc.info/gems/responders/ActionController/RespondWith#respond_with-instance_method
    #   respond_with}
    # @yield [format] block for
    #   {https://www.rubydoc.info/gems/responders/ActionController/RespondWith#respond_with-instance_method
    #   respond_with}
    #   to customize response behaviour.
    # @raise [Forbidden] if user has no access
    def index(**responder_options, &block)
      current_authorizer.authorize :index, current_model_class
      respond_with collection, responder_options, &block
    end
    alias index! index

    # @note This is a template method that can be overridden by subclasses.
    # This is a resourcesful action to show the form to create record that user is allowed to.
    #
    # It can be customized as below in subclasses:
    #
    #     def new
    #       # do something before the original action
    #       responder_options = {} # NOTE: see `responder_options` parameter for more details
    #       # NOTE: this is better than using `super` in many ways, but choose the one that better fits your scenario
    #       new!(responder_options) do |format|
    #         # NOTE: this block is for `respond_with` which works similar to `respond_to`
    #         # customize response behaviour, or do something before the request is rendered
    #       end
    #     end
    #
    # Otherwise, it can be replaced completely in subclasses:
    #
    #     def new
    #       # NOTE: `@resource` will be used by the view, please ensure it is assigned, for example:
    #       @resource = Product.new new_arrival: true
    #     end
    # @param responder_options [Hash] (since wallaby-5.2.0) responder_options for
    #   {https://www.rubydoc.info/gems/responders/ActionController/RespondWith#respond_with-instance_method
    #   respond_with}
    # @yield [format] block for
    #   {https://www.rubydoc.info/gems/responders/ActionController/RespondWith#respond_with-instance_method
    #   respond_with}
    #   to customize response behaviour.
    # @raise [Forbidden] if user has no access
    def new(**responder_options, &block)
      current_authorizer.authorize :new, new_resource
      respond_with new_resource, responder_options, &block
    end
    alias new! new

    # @note This is a template method that can be overridden by subclasses.
    # This is a resourcesful action to create a record that user is allowed to.
    #
    # If record is created successfully, user will be navigated to the record show page.
    # Otherwise, the form will be shown again with error messages.
    #
    # It can be customized as below in subclasses:
    #
    #     def create
    #       # do something before the original action
    #       responder_options = {} # NOTE: see `responder_options` parameter for more details
    #       # NOTE: this is better than using `super` in many ways, but choose the one that better fits your scenario
    #       create!(responder_options) do |format|
    #         # NOTE: this block is for `respond_with` which works similar to `respond_to`
    #         # customize response behaviour, or do something before the request is rendered
    #       end
    #     end
    #
    # Otherwise, it can be replaced completely in subclasses:
    #
    #     def create
    #       # NOTE: `@resource` will be used by the view, please ensure it is assigned, for example:
    #       @resource = Product.new resource_params.merge(new_arrival: true)
    #       if @resource.save
    #         redirect_to helper.index_path(current_model_class)
    #       else
    #         render :new
    #       end
    #     end
    # @param responder_options [Hash] (since wallaby-5.2.0) responder_options for
    #   {https://www.rubydoc.info/gems/responders/ActionController/RespondWith#respond_with-instance_method
    #   respond_with}. In addition, responder_options `:params` is supported, see below
    # @option responder_options [Hash, ActionController::Parameters] :params
    #   permitted parameters for servicer to create the record. _(defaults to: {#resource_params})_
    # @yield [format] block for
    #   {https://www.rubydoc.info/gems/responders/ActionController/RespondWith#respond_with-instance_method
    #   respond_with}
    #   to customize response behaviour.
    # @raise [Forbidden] if user has no access
    def create(location: -> { show_path new_resource }, **responder_options, &block)
      current_authorizer.authorize :create, new_resource
      current_servicer.create new_resource, create_params
      respond_with new_resource, responder_options.merge(location: location), &block
    end
    alias create! create

    # @note This is a template method that can be overridden by subclasses.
    # This is a resourcesful action to display the record details that user is allowed to.
    #
    # It can be customized as below in subclasses:
    #
    #     def show
    #       # do something before the original action
    #       responder_options = {} # NOTE: see `responder_options` parameter for more details
    #       # NOTE: this is better than using `super` in many ways, but choose the one that better fits your scenario
    #       show!(responder_options) do |format|
    #         # NOTE: this block is for `respond_with` which works similar to `respond_to`
    #         # customize response behaviour, or do something before the request is rendered
    #       end
    #     end
    #
    # Otherwise, it can be replaced completely in subclasses:
    #
    #     def show
    #       # NOTE: `@resource` will be used by the view, please ensure it is assigned, for example:
    #       @resource = Product.find_by_slug params[:id]
    #     end
    # @param responder_options [Hash] (since wallaby-5.2.0) responder_options for
    #   {https://www.rubydoc.info/gems/responders/ActionController/RespondWith#respond_with-instance_method
    #   respond_with}
    # @yield [format] block for
    #   {https://www.rubydoc.info/gems/responders/ActionController/RespondWith#respond_with-instance_method
    #   respond_with}
    #   to customize response behaviour.
    # @raise [Forbidden] if user has no access
    def show(**responder_options, &block)
      current_authorizer.authorize :show, resource
      respond_with resource, responder_options, &block
    end
    alias show! show

    # @note This is a template method that can be overridden by subclasses.
    # This is a resourcesful action to show the form to edit record that user is allowed to.
    #
    # It can be customized as below in subclasses:
    #
    #     def edit
    #       # do something before the original action
    #       responder_options = {} # NOTE: see `responder_options` parameter for more details
    #       # NOTE: this is better than using `super` in many ways, but choose the one that better fits your scenario
    #       edit!(responder_options) do |format|
    #         # NOTE: this block is for `respond_with` which works similar to `respond_to`
    #         # customize response behaviour, or do something before the request is rendered
    #       end
    #     end
    #
    # Otherwise, it can be replaced completely in subclasses:
    #
    #     def edit
    #       # NOTE: `@resource` will be used by the view, please ensure it is assigned, for example:
    #       @resource = Product.find_by_slug params[:id]
    #     end
    # @param responder_options [Hash] (since wallaby-5.2.0) responder_options for
    #   {https://www.rubydoc.info/gems/responders/ActionController/RespondWith#respond_with-instance_method
    #   respond_with}
    # @yield [format] block for
    #   {https://www.rubydoc.info/gems/responders/ActionController/RespondWith#respond_with-instance_method
    #   respond_with}
    #   to customize response behaviour.
    # @raise [Forbidden] if user has no access
    def edit(**responder_options, &block)
      current_authorizer.authorize :edit, resource
      respond_with resource, responder_options, &block
    end
    alias edit! edit

    # @note This is a template method that can be overridden by subclasses.
    # This is a resourcesful action to update the record that user is allowed to.
    #
    # If record is updated successfully, user will be navigated to the record show page.
    # Otherwise, the form will be shown again with error messages.
    #
    # It can be customized as below in subclasses:
    #
    #     def update
    #       # do something before the original action
    #       responder_options = {} # NOTE: see `responder_options` parameter for more details
    #       # NOTE: this is better than using `super` in many ways, but choose the one that better fits your scenario
    #       update!(responder_options) do |format|
    #         # NOTE: this block is for `respond_with` which works similar to `respond_to`
    #         # customize response behaviour, or do something before the request is rendered
    #       end
    #     end
    #
    # Otherwise, it can be replaced completely in subclasses:
    #
    #     def update
    #       # NOTE: `@resource` will be used by the view, please ensure it is assigned, for example:
    #       @resource = Product.find_by_slug params[:id]
    #       @resource.assign_attributes resource_params.merge(new_arrival: true)
    #       if @resource.save
    #         redirect_to helper.index_path(current_model_class)
    #       else
    #         render :new
    #       end
    #     end
    # @param responder_options [Hash] (since wallaby-5.2.0) responder_options for
    #   {https://www.rubydoc.info/gems/responders/ActionController/RespondWith#respond_with-instance_method
    #   respond_with}. In addition, responder_options `:params` is supported, see below
    # @option responder_options [Hash, ActionController::Parameters] :params
    #   permitted parameters for servicer to update the record. _(defaults to: {#resource_params})_
    # @yield [format] block for
    #   {https://www.rubydoc.info/gems/responders/ActionController/RespondWith#respond_with-instance_method
    #   respond_with}
    #   to customize response behaviour.
    # @raise [Forbidden] if user has no access
    def update(location: -> { show_path resource }, **responder_options, &block)
      current_authorizer.authorize :update, resource
      current_servicer.update resource, update_params
      respond_with resource, ({ location: location }).merge(responder_options), &block
    end
    alias update! update

    # @note This is a template method that can be overridden by subclasses.
    # This is a resourcesful action to delete the record that user is allowed to.
    #
    # It can be customized as below in subclasses:
    #
    #     def destroy
    #       # do something before the original action
    #       responder_options = {} # NOTE: see `responder_options` parameter for more details
    #       # NOTE: this is better than using `super` in many ways, but choose the one that better fits your scenario
    #       destroy!(responder_options) do |format|
    #         # NOTE: this block is for `respond_with` which works similar to `respond_to`
    #         # customize response behaviour, or do something before the request is rendered
    #       end
    #     end
    #
    # Otherwise, it can be replaced completely in subclasses:
    #
    #     def destroy
    #       # NOTE: `@resource` will be used by the view, please ensure it is assigned, for example:
    #       @resource = Product.find_by_slug params[:id]
    #       @resource.destroy
    #       redirect_to helper.index_path(current_model_class)
    #     end
    # @param responder_options [Hash] (since wallaby-5.2.0) responder_options for
    #   {https://www.rubydoc.info/gems/responders/ActionController/RespondWith#respond_with-instance_method
    #   respond_with}. In addition, responder_options `:params` is supported, see below
    # @option responder_options [Hash, ActionController::Parameters] :params
    #   permitted parameters for servicer to destroy the record. _(defaults to: {#resource_params})_
    # @yield [format] block for
    #   {https://www.rubydoc.info/gems/responders/ActionController/RespondWith#respond_with-instance_method
    #   respond_with}
    #   to customize response behaviour.
    # @raise [Forbidden] if user has no access
    def destroy(location: -> { index_path current_model_class }, **responder_options, &block)
      current_authorizer.authorize :destroy, resource
      current_servicer.destroy resource
      respond_with resource, ({ location: location }).merge(responder_options), &block
    end
    alias destroy! destroy
  end
end
