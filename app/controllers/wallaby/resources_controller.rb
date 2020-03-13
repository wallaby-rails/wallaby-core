# frozen_string_literal: true

module Wallaby
  ResourcesController = Class.new configuration.base_controller

  # Resources controller, superclass for all customization controllers.
  # It contains CRUD template action methods (`index`/`new`/`create`/`edit`/`update`/`destroy`)
  # that allow subclasses to override.
  class ResourcesController
    include ResourcesConcern
  end
end
