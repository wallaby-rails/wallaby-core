require 'rails_helper'

describe Wallaby::ConfigurationHelper, type: :helper do
  describe '#default_metadata' do
    it { expect { helper.default_metadata }.to raise_error Wallaby::MethodRemoved }
  end
end
