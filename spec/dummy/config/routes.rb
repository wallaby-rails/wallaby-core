Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  begin # all sorts of mounted path to check if wallaby gets confused or not.
    get '/admin/abc', to: Wallaby::ResourcesRouter.new, as: :abc
    namespace :core do
      mount Wallaby::Engine, at: '/admin', as: :nested_engine
    end
    scope path: '/main' do
      mount Wallaby::Engine, at: '/admin', as: :main_engine
    end
    mount Wallaby::Engine, at: '/admin_else', as: :manager_engine
    mount Wallaby::Engine, at: '/before_engine', as: :before_engine
    # NOTE this is the part that we should focus
    wallaby_mount at: '/admin' do
      # ordinary categories resources
      resources :categories, module: :admin do
        get :member_only, on: :member
        get :collection_only, on: :collection
      end

      # custom controller for categories as well
      resources :not_like_categories, module: :admin do
        get :member_only, on: :member
        get :collection_only, on: :collection
      end
    end
    mount Wallaby::Engine, at: '/after_engine', as: :after_engine
    mount Wallaby::Engine, at: '/inner', as: :inner_engine, defaults: { resources_controller: InnerController }
  end
  get '/something/else', to: 'wallaby/resources#index', defaults: { resources: 'products' }

  begin # for non-admin usage
    # testing custom mode purpose
    wresources :postcodes, controller: 'wallaby/resources'
    wresources :zipcodes, controller: 'wallaby/resources'
    wresource :profile, controller: 'wallaby/resources' do
      wresources :postcodes, controller: 'wallaby/resources'
    end

    # testing theming purpose
    resources :blogs do
      get :prefixes, on: :collection
    end

    # others
    resources :orders do
      resources :items do
        get :prefixes, on: :collection
      end
    end

    resources :categories
    wresources :products, controller: 'wallaby/resources'
    wresources :pictures, controller: 'wallaby/resources'

    scope path: '/before', as: :before do
      wresources :products, controller: 'wallaby/resources'
      wresources :pictures, controller: 'wallaby/resources'
    end

    scope path: '/after', as: :after do
      wresources :products, controller: 'wallaby/resources'
      wresources :pictures, controller: 'wallaby/resources'
    end

    scope path: '/api', as: :api do
      wresources :pictures, controller: 'json_api'
    end

    namespace :json do
      resources :pictures
    end
  end

  get '/test/purpose', to: 'application#index'
end
