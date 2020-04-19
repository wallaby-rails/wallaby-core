# frozen_string_literal: true

# NOTE: this file will be loaded after main app's routes.
# And these routes should be appended to the end of engine's routes
# to allow adding custom routes to the engine itself.
Wallaby::Engine.routes.append do
  # NOTE: Check to prevent this from being loaded for more than once while Rails reloads
  next if @set.routes.find { |r| r.name == 'resources' }

  # NOTE: For health check if needed
  # @see Wallaby::ApplicationController#healthy
  get 'status', to: 'wallaby/resources#healthy'

  with_options to: Wallaby::ResourcesRouter.new do |route|
    # @see `home` action for more
    route.root defaults: { action: 'home' }

    # To generate error pages for all supported HTTP status
    Wallaby::ERRORS.each do |status|
      code = Rack::Utils::SYMBOL_TO_STATUS_CODE[status]
      route.get status, defaults: { action: status }
      route.get code.to_s, defaults: { action: status }
    end

    # To generate general CRUD resourceful routes
    # @see Wallaby::ResourcesRouter
    scope path: ':resources' do
      # @see Wallaby::ResourcesController#index
      route.get '', defaults: { action: 'index' }, as: :resources
      # @see Wallaby::ResourcesController#new
      route.get 'new', defaults: { action: 'new' }, as: :new_resource
      # @see Wallaby::ResourcesController#edit
      route.get ':id/edit', defaults: { action: 'edit' }, as: :edit_resource
      # @see Wallaby::ResourcesController#show
      route.get ':id', defaults: { action: 'show' }, as: :resource

      # @see Wallaby::ResourcesController#create
      route.post '', defaults: { action: 'create' }
      # @see Wallaby::ResourcesController#update
      route.match ':id', via: %i(patch put), defaults: { action: 'update' }
      # @see Wallaby::ResourcesController#destroy
      route.delete ':id', defaults: { action: 'destroy' }
    end
  end
end
