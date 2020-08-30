module RequestSupport
  def http(verb, url, hash = {})
    if Rails::VERSION::MAJOR == 4
      send verb, url, hash[:params], hash[:headers]
    else
      send verb, url, **hash
    end
  end
end

RSpec.configure do |config|
  config.include RequestSupport, type: :request
end
