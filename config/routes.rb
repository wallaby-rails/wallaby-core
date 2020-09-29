# frozen_string_literal: true

# NOTE: this file will be loaded after main app's routes.
# And these routes should be appended to the end of {Wallaby::Engine}'s routes
# to allow adding custom routes to the {Wallaby::Engine} itself.
Wallaby::Engine.routes.append do
  # NOTE: Check to prevent this from being loaded again while Rails reloads
  next if @set.routes.find { |r| r.name == 'resources' }

  # NOTE: For health check if needed
  # @see Wallaby::ApplicationConcern#healthy
  get 'status', to: 'wallaby/resources#healthy'

  with_options to: Wallaby::ResourcesRouter.new do |route|
    # @see Wallaby::ResourcesConcern#home
    route.root defaults: { action: 'home' }

    # To generate error pages for all supported HTTP status in {Wallaby::ERRORS}
    Wallaby::ERRORS.each do |status|
      code = Rack::Utils::SYMBOL_TO_STATUS_CODE[status]
      route.get status, defaults: { action: status }
      route.get code.to_s, defaults: { action: status }
    end

    # To generate general CRUD resourcesful routes
    # @see Wallaby::ResourcesRouter
    scope path: ':resources' do
      # @see Wallaby::ResourcesConcern#index
      route.get '', defaults: { action: 'index' }, as: :resources
      # @see Wallaby::ResourcesConcern#new
      route.get 'new', defaults: { action: 'new' }, as: :new_resource
      # @see Wallaby::ResourcesConcern#edit
      route.get ':id/edit', defaults: { action: 'edit' }, as: :edit_resource
      # @see Wallaby::ResourcesConcern#show
      route.get ':id', defaults: { action: 'show' }, as: :resource

      # @see Wallaby::ResourcesConcern#create
      route.post '', defaults: { action: 'create' }
      # @see Wallaby::ResourcesConcern#update
      route.match ':id', via: %i(patch put), defaults: { action: 'update' }
      # @see Wallaby::ResourcesConcern#destroy
      route.delete ':id', defaults: { action: 'destroy' }
    end
  end
end
