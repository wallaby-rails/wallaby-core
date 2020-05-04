require 'rails_helper'

describe Wallaby::ConfigurationHelper do
  describe '#configuration' do
    it { expect(helper.configuration).to be_a Wallaby::Configuration }
  end

  describe '#controller_configuration' do
    it { expect(helper.controller_configuration).to eq Wallaby::ResourcesController }
  end

  describe '#max_text_length' do
    it { expect(helper.max_text_length).to eq Wallaby::DEFAULT_MAX }
  end
end
