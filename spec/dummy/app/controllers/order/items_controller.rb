module Orders
  class ItemsController < BaseController
    self.model_class = Order::Item
  end
end
