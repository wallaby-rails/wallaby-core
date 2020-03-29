# frozen_string_literal: true

module Wallaby
  # Type renderer
  class TypeRenderer
    class << self
      # Render partial
      # @param view [ActionView]
      # @param options [Hash]
      # @param locals [Hash]
      # @return [String] HTML
      def render(view, options = {}, locals = {}, &block)
        locals[:object] ||= locals[:form].try :object
        check locals
        complete locals, view.params[:action]
        view.render options, locals, &block
      end

      private

      # @param locals [Hash]
      # @raise [ArgumentError] if form is set but blank
      # @raise [ArgumentError] if field_name is not provided
      # @raise [ArgumentError] if object is not decorated
      def check(locals)
        raise ArgumentError, Locale.t('errors.required', subject: 'form') if locals.key?(:form) && locals[:form].blank?
        raise ArgumentError, Locale.t('errors.required', subject: 'field_name') if locals[:field_name].blank?
        raise ArgumentError, 'Object is not decorated.' unless locals[:object].is_a? ResourceDecorator
      end

      # @param locals [Hash]
      # @param action [String]
      def complete(locals, action)
        action_name = FORM_ACTIONS[action] || action
        locals[:metadata] = locals[:object].public_send :"#{action_name}_metadata_of", locals[:field_name]
        locals[:value] = locals[:object].public_send locals[:field_name]
      end
    end
  end
end
