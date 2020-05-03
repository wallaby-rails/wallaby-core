RSpec.configure do |config|
  config.before do
    Wallaby.configuration.resources_controller.try(:clear)
    Wallaby.configuration.clear
    Wallaby::Map.clear
    RequestStore
  end

  config.around :suite do |example|
    Wallaby.configuration.resources_controller.try(:clear)
    Wallaby.configuration.clear
    Wallaby::Map.clear
    const_before = Object.constants
    example.run
    const_after = Object.constants
    (const_after - const_before).each do |const|
      Object.send :remove_const, const
    end
  end
end
