class Order::ItemsController < Wallaby::ResourcesController
  self.namespace = ''

  def index
    index!
  end
end
