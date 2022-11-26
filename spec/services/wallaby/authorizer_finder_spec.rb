# frozen_string_literal: true
require 'rails_helper'

describe Wallaby::AuthorizerFinder do
  describe '#execute' do
    subject { described_class.new(script_name: script_name, model_class: model_class, current_controller_class: current_controller_class).execute }

    let(:script_name) { '/admin' }
    let(:model_class) { User }
    let(:current_controller_class) { admin_application_controller }

    let!(:admin_application_controller) { Wallaby::ResourcesController }
    let!(:admin_application_authorizer) { Wallaby::ModelAuthorizer }
    let!(:user) { stub_const('User', Class.new) }
    let!(:users_controller) do
      stub_const(
        'UsersController',
        Class.new(::ApplicationController) do
          include Wallaby::ResourcesConcern
        end
      )
    end

    it { is_expected.to eq Wallaby::ModelAuthorizer }

    context 'when admin application controller exists' do
      let!(:admin_application_controller) { stub_const('Admin::ApplicationController', base_class_from(Wallaby::ResourcesController)) }

      it { is_expected.to eq Wallaby::ModelAuthorizer }

      context 'when admin application authorizer exists' do
        let!(:admin_application_authorizer) { stub_const('Admin::ApplicationAuthorizer', base_class_from(Wallaby::ModelAuthorizer)) }

        it { is_expected.to eq Admin::ApplicationAuthorizer }
      end
    end

    context 'when admin users controller exists (admin interface)' do
      let!(:admin_products_controller) { stub_const('Admin::ProductsController', Class.new(admin_application_controller)) }
      let!(:admin_users_controller) { stub_const('Admin::UsersController', Class.new(admin_application_controller)) }
      let!(:admin_custom_users_controller) { stub_const('Admin::Custom::UsersController', Class.new(admin_application_controller)) }

      it { is_expected.to eq Wallaby::ModelAuthorizer }

      context 'when current controller is admin users controller' do
        let(:current_controller_class) { admin_users_controller }

        it { is_expected.to eq Wallaby::ModelAuthorizer }
      end

      context 'when current controller is admin products controller' do
        let(:current_controller_class) { admin_products_controller }

        it { is_expected.to eq Wallaby::ModelAuthorizer }
      end

      context 'when current controller is admin custom users controller' do
        let(:current_controller_class) { admin_custom_users_controller }

        it { is_expected.to eq Wallaby::ModelAuthorizer }

        context 'when custom authorizer exists' do
          let!(:admin_custom_user_authorizer) { stub_const('Admin::Custom::UserAuthorizer', Class.new(admin_application_authorizer)) }

          it { is_expected.to eq Admin::Custom::UserAuthorizer }
        end
      end

      context 'when admin application controller exists' do
        let!(:admin_application_controller) { stub_const('Admin::ApplicationController', base_class_from(Wallaby::ResourcesController)) }

        it { is_expected.to eq Wallaby::ModelAuthorizer }

        context 'when current controller is admin users controller' do
          let(:current_controller_class) { admin_users_controller }

          it { is_expected.to eq Wallaby::ModelAuthorizer }
        end

        context 'when current controller is admin products controller' do
          let(:current_controller_class) { admin_products_controller }

          it { is_expected.to eq Wallaby::ModelAuthorizer }
        end

        context 'when current controller is admin custom users controller' do
          let(:current_controller_class) { admin_custom_users_controller }

          it { is_expected.to eq Wallaby::ModelAuthorizer }

          context 'when custom authorizer exists' do
            let!(:admin_custom_user_authorizer) { stub_const('Admin::Custom::UserAuthorizer', Class.new(admin_application_authorizer)) }

            it { is_expected.to eq Admin::Custom::UserAuthorizer }
          end
        end

        context 'when admin application authorizer exists' do
          let!(:admin_application_authorizer) { stub_const('Admin::ApplicationAuthorizer', base_class_from(Wallaby::ModelAuthorizer)) }

          it { is_expected.to eq Admin::ApplicationAuthorizer }

          context 'when current controller is admin users controller' do
            let(:current_controller_class) { admin_users_controller }

            it { is_expected.to eq Admin::ApplicationAuthorizer }
          end

          context 'when current controller is admin products controller' do
            let(:current_controller_class) { admin_products_controller }

            it { is_expected.to eq Admin::ApplicationAuthorizer }
          end

          context 'when current controller is admin custom users controller' do
            let(:current_controller_class) { admin_custom_users_controller }

            it { is_expected.to eq Admin::ApplicationAuthorizer }

            context 'when custom authorizer exists' do
              let!(:admin_custom_user_authorizer) { stub_const('Admin::Custom::UserAuthorizer', Class.new(admin_application_authorizer)) }

              it { is_expected.to eq Admin::Custom::UserAuthorizer }
            end
          end

          context 'when admin User authorizer exists' do
            let!(:admin_user_authorizer) { stub_const('Admin::UserAuthorizer', base_class_from(admin_application_authorizer)) }

            it { is_expected.to eq Admin::UserAuthorizer }

            context 'when current controller is admin users controller' do
              let(:current_controller_class) { admin_users_controller }

              it { is_expected.to eq Admin::UserAuthorizer }
            end

            context 'when current controller is admin products controller' do
              let(:current_controller_class) { admin_products_controller }

              it { is_expected.to eq Admin::UserAuthorizer }
            end

            context 'when current controller is admin custom users controller' do
              let(:current_controller_class) { admin_custom_users_controller }

              it { is_expected.to eq Admin::UserAuthorizer }

              context 'when custom authorizer exists' do
                let!(:admin_custom_user_authorizer) { stub_const('Admin::Custom::UserAuthorizer', Class.new(admin_application_authorizer)) }

                it { is_expected.to eq Admin::Custom::UserAuthorizer }
              end
            end
          end
        end
      end
    end

    context 'when script name is blank (general usage)' do
      let(:script_name) { '' }
      let(:current_controller_class) { users_controller }
      let(:admin_application_authorizer) { Wallaby::ModelAuthorizer }

      it { is_expected.to eq Wallaby::ModelAuthorizer }

      context 'when user authorizer exists' do
        let!(:user_authorizer) { stub_const('UserAuthorizer', base_class_from(admin_application_authorizer)) }
        let!(:admin_user_authorizer) { stub_const('Admin::UserAuthorizer', base_class_from(admin_application_authorizer)) }

        it { is_expected.to eq UserAuthorizer }
      end
    end
  end
end
