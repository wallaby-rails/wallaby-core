require 'rails_helper'

describe Wallaby::ResourcesController, type: :controller do
  describe '.resource_decorator && .application_decorator' do
    it 'returns nil' do
      expect(described_class.resource_decorator).to be_nil
      expect(described_class.application_decorator).to eq Wallaby::ResourceDecorator
    end

    context 'when subclass' do
      let!(:application_controller) { stub_const 'Admin::ApplicationController', Class.new(described_class) }
      let!(:subclass1) { stub_const 'ApplesController', Class.new(application_controller) }
      let!(:subclass2) { stub_const 'ThingsController', Class.new(subclass1) }
      let!(:application_decorator) { stub_const 'ApplicationDecorator', base_class_from(Wallaby::ResourceDecorator) }
      let!(:another_application_decorator) { stub_const 'AnotherApplicationDecorator', base_class_from(application_decorator) }
      let!(:apple_decorator) { stub_const 'AppleDecorator', Class.new(another_application_decorator) }
      let!(:thing_decorator) { stub_const 'ThingDecorator', Class.new(apple_decorator) }
      let!(:apple) { stub_const 'Apple', Class.new(ActiveRecord::Base) }
      let!(:thing) { stub_const 'Thing', Class.new(ActiveRecord::Base) }

      it 'is nil' do
        expect(subclass1.resource_decorator).to be_nil
        expect(subclass1.application_decorator).to eq application_decorator
        expect(subclass2.resource_decorator).to be_nil
        expect(subclass2.application_decorator).to eq application_decorator
      end

      it 'returns decorator classes' do
        subclass1.resource_decorator = apple_decorator
        expect(subclass1.resource_decorator).to eq apple_decorator
        expect(subclass2.resource_decorator).to be_nil

        subclass1.application_decorator = another_application_decorator
        expect(subclass1.application_decorator).to eq another_application_decorator
        expect(subclass2.application_decorator).to eq another_application_decorator
      end
    end
  end
end