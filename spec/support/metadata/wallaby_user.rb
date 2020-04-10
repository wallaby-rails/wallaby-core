RSpec.configure do |config|
  config.before do |example|
    if example.metadata.key? :wallaby_user
      allow(controller).to receive(:current_user) { example.metadata[:wallaby_user] }
      allow(controller).to receive(:wallaby_user) { example.metadata[:wallaby_user] }
    end
  end
end
