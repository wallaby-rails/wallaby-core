module Auth
  def cancancan_context(ability)
    OpenStruct.new current_ability: ability
  end
end

RSpec.configure do |config|
  config.include Auth
end
