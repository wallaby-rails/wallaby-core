require 'rails_helper'

describe Wallaby::ResourcesController, type: :controller do
  describe '.resource_decorator && .application_decorator' do
    it 'returns decorator class' do
      expect(described_class.resource_decorator).to eq nil
      expect(described_class.application_decorator).to eq Wallaby::ResourceDecorator
    end

    context 'when subclass' do
      let!(:application_controller) { stub_const 'Admin::ApplicationController', base_class_from(described_class) }
      let!(:subclass1) { stub_const 'ApplesController', Class.new(application_controller) }
      let!(:subclass2) { stub_const 'ThingsController', Class.new(subclass1) }
      let!(:application_decorator) { stub_const 'ApplicationDecorator', base_class_from(Wallaby::ResourceDecorator) }
      let!(:another_application_decorator) { stub_const 'AnotherApplicationDecorator', base_class_from(application_decorator) }
      let!(:apple_decorator) { stub_const 'AppleDecorator', Class.new(another_application_decorator) }
      let!(:thing_decorator) { stub_const 'ThingDecorator', Class.new(apple_decorator) }
      let!(:apple) { stub_const 'Apple', Class.new(ActiveRecord::Base) }
      let!(:thing) { stub_const 'Thing', Class.new(ActiveRecord::Base) }

      it 'returns decorator class' do
        expect(subclass1.resource_decorator).to eq AppleDecorator
        expect(subclass1.application_decorator).to eq ApplicationDecorator
        expect(subclass2.resource_decorator).to eq ThingDecorator
        expect(subclass2.application_decorator).to eq ApplicationDecorator
      end
    end
  end

  describe '.models && .models_to_exclude && .all_models' do
    it 'returns models' do
      expect(described_class.models).to be_blank
      expect(described_class.models_to_exclude.to_a).to include(ActiveRecord::SchemaMigration)
      expect(described_class.models_to_exclude.to_a).to include(ActiveRecord::InternalMetadata) if version?('>= 6.0')
      expect(described_class.all_models).not_to include(ActiveRecord::SchemaMigration)
      expect(described_class.all_models).not_to include(ActiveRecord::InternalMetadata) if version?('>= 6.0')
    end

    context 'when subclass' do
      let!(:application_controller) { stub_const 'Admin::ApplicationController', base_class_from(described_class) }

      it 'returns models' do
        expect(application_controller.models).to be_blank
        expect(application_controller.models_to_exclude.to_a).to include(ActiveRecord::SchemaMigration)
        if version?('>= 5.2')
          expect(application_controller.models_to_exclude.to_a).to include(ActiveRecord::InternalMetadata)
        end
        expect(application_controller.all_models).not_to include(ActiveRecord::SchemaMigration)
        expect(application_controller.all_models).not_to include(ActiveRecord::InternalMetadata) if version?('>= 5.2')

        Admin::ApplicationController.models_to_exclude = Product, *Admin::ApplicationController.models_to_exclude.to_a
        expect(application_controller.models).to be_blank
        expect(application_controller.models_to_exclude.to_a).to include(Product)
        expect(application_controller.all_models).not_to include(Product)

        Admin::ApplicationController.models = Product
        expect(application_controller.models.to_a).to eq([Product])
        expect(application_controller.models_to_exclude.to_a).to include(Product)
        expect(application_controller.all_models).to include(Product)
      end
    end
  end
end
