require 'rails_helper'

describe Wallaby::ConfigurationHelper, type: :helper do
  describe '#default_metadata' do
    it { expect { helper.default_metadata }.to raise_error Wallaby::MethodRemoved }
  end
end

describe Wallaby::Configuration::Mapping do
  describe '#resources_controller=' do
    it { expect { subject.resources_controller = nil }.to raise_error Wallaby::MethodRemoved }
  end

  describe '#resources_controller' do
    it { expect { subject.resources_controller }.to raise_error Wallaby::MethodRemoved }
  end

  describe '#resource_decorator=' do
    it { expect { subject.resource_decorator = nil }.to raise_error Wallaby::MethodRemoved }
  end

  describe '#resource_decorator' do
    it { expect { subject.resource_decorator }.to raise_error Wallaby::MethodRemoved }
  end

  describe '#model_servicer=' do
    it { expect { subject.model_servicer = nil }.to raise_error Wallaby::MethodRemoved }
  end

  describe '#model_servicer' do
    it { expect { subject.model_servicer }.to raise_error Wallaby::MethodRemoved }
  end

  describe '#model_authorizer=' do
    it { expect { subject.model_authorizer = nil }.to raise_error Wallaby::MethodRemoved }
  end

  describe '#model_authorizer' do
    it { expect { subject.model_authorizer }.to raise_error Wallaby::MethodRemoved }
  end

  describe '#model_paginator=' do
    it { expect { subject.model_paginator = nil }.to raise_error Wallaby::MethodRemoved }
  end

  describe '#model_paginator' do
    it { expect { subject.model_paginator }.to raise_error Wallaby::MethodRemoved }
  end
end

describe Wallaby::Configuration::Metadata do
  describe '#max=' do
    it { expect { subject.max = nil }.to raise_error Wallaby::MethodRemoved }
  end

  describe '#max' do
    it { expect { subject.max }.to raise_error Wallaby::MethodRemoved }
  end
end

describe Wallaby::Configuration::Models do
  describe '#set' do
    it { expect { subject.set nil }.to raise_error Wallaby::MethodRemoved }
  end

  describe '#presence' do
    it { expect { subject.presence }.to raise_error Wallaby::MethodRemoved }
  end

  describe '#exclude' do
    it { expect { subject.exclude nil }.to raise_error Wallaby::MethodRemoved }
  end

  describe '#excludes' do
    it { expect { subject.excludes }.to raise_error Wallaby::MethodRemoved }
  end
end

describe Wallaby::Configuration::Pagination do
  describe '#page_size=' do
    it { expect { subject.page_size = nil }.to raise_error Wallaby::MethodRemoved }
  end

  describe '#page_size' do
    it { expect { subject.page_size }.to raise_error Wallaby::MethodRemoved }
  end
end

describe Wallaby::Configuration::Security do
  describe '#logout_path=' do
    it { expect { subject.logout_path = nil }.to raise_error Wallaby::MethodRemoved }
  end

  describe '#logout_path' do
    it { expect { subject.logout_path }.to raise_error Wallaby::MethodRemoved }
  end

  describe '#logout_method=' do
    it { expect { subject.logout_method = nil }.to raise_error Wallaby::MethodRemoved }
  end

  describe '#logout_method' do
    it { expect { subject.logout_method }.to raise_error Wallaby::MethodRemoved }
  end

  describe '#email_method=' do
    it { expect { subject.email_method = nil }.to raise_error Wallaby::MethodRemoved }
  end

  describe '#email_method' do
    it { expect { subject.email_method }.to raise_error Wallaby::MethodRemoved }
  end

  describe '#current_user' do
    it { expect { subject.current_user { 'test' } }.to raise_error Wallaby::MethodRemoved }
  end

  describe '#current_user?' do
    it { expect { subject.current_user? }.to raise_error Wallaby::MethodRemoved }
  end

  describe '#authenticate' do
    it { expect { subject.authenticate { 'test' } }.to raise_error Wallaby::MethodRemoved }
  end

  describe '#authenticate?' do
    it { expect { subject.authenticate? }.to raise_error Wallaby::MethodRemoved }
  end
end

describe Wallaby::Configuration::Sorting do
  describe '#strategy=' do
    it { expect { subject.strategy = nil }.to raise_error Wallaby::MethodRemoved }
  end

  describe '#strategy' do
    it { expect { subject.strategy }.to raise_error Wallaby::MethodRemoved }
  end
end
