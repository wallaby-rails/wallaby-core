# frozen_string_literal: true

module Wallaby
  class Custom
    # Model service provider
    class ModelServiceProvider < ::Wallaby::ModelServiceProvider
      # @raise [Wallaby::NotImplemented]
      def permit(*)
        raise Wallaby::NotImplemented, Wallaby.t('errors.not_implemented.model_servicer', method_name: __callee__)
      end

      # @raise [Wallaby::NotImplemented]
      def collection(*)
        raise Wallaby::NotImplemented, Wallaby.t('errors.not_implemented.model_servicer', method_name: __callee__)
      end

      # @raise [Wallaby::NotImplemented]
      def paginate(*)
        raise Wallaby::NotImplemented, Wallaby.t('errors.not_implemented.model_servicer', method_name: __callee__)
      end

      # @raise [Wallaby::NotImplemented]
      def new(*)
        raise Wallaby::NotImplemented, Wallaby.t('errors.not_implemented.model_servicer', method_name: __callee__)
      end

      # @raise [Wallaby::NotImplemented]
      def find(*)
        raise Wallaby::NotImplemented, Wallaby.t('errors.not_implemented.model_servicer', method_name: __callee__)
      end

      # @raise [Wallaby::NotImplemented]
      def create(*)
        raise Wallaby::NotImplemented, Wallaby.t('errors.not_implemented.model_servicer', method_name: __callee__)
      end

      # @raise [Wallaby::NotImplemented]
      def update(*)
        raise Wallaby::NotImplemented, Wallaby.t('errors.not_implemented.model_servicer', method_name: __callee__)
      end

      # @raise [Wallaby::NotImplemented]
      def destroy(*)
        raise Wallaby::NotImplemented, Wallaby.t('errors.not_implemented.model_servicer', method_name: __callee__)
      end
    end
  end
end
