# frozen_string_literal: true

module Wallaby
  ResourcesController = Class.new configuration.base_controller

  # Resources controller, superclass for all customization controllers.
  # It contains CRUD template action methods
  # ({Wallaby::ResourcesConcern#index #index} / {Wallaby::ResourcesConcern#new #new}
  # / {Wallaby::ResourcesConcern#create #create} / {Wallaby::ResourcesConcern#edit #edit}
  # / {Wallaby::ResourcesConcern#update #update} / {Wallaby::ResourcesConcern#destroy #destroy})
  # that allow subclasses to override.
  #
  # For better practice, please create an application controller class (see example)
  # to better control the functions shared between different resource controllers.
  # @example Create an application class for Admin Interface usage
  #   class Admin::ApplicationController < Wallaby::ResourcesController
  #     base_class!
  #   end
  class ResourcesController
    include ResourcesConcern
  end
end
