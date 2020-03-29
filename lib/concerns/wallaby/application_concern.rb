# frozen_string_literal: true

module Wallaby
  # Here, it provides the most basic functions e.g. error handling for common 4xx HTTP status, helpers method,
  # and URL handling.
  module ApplicationConcern
    extend ActiveSupport::Concern

    # @!parse
    #   extend Engineable::ClassMethods
    #   include Engineable
    #   include SharedHelpers

    # @!method healthy
    # Health check page

    # @!method not_found(exception = nil)
    # Not found page
    # @param exception [Exception] comes from **rescue_from**

    # @!method bad_request(exception = nil)
    # Bad request page
    # @param exception [Exception] comes from **rescue_from**

    # @!method unprocessable_entity(exception = nil)
    # Unprocessable entity page
    # @param exception [Exception] comes from **rescue_from**

    # @!method internal_server_error(exception = nil)
    # Internal server error page
    # @param exception [Exception] comes from **rescue_from**

    # @!method not_implemented(exception = nil)
    # Not implemented
    # @param exception [Exception] comes from **rescue_from**

    # @!method helpers
    # {https://api.rubyonrails.org/classes/ActionController/Helpers.html#method-i-helpers helpers}
    # exists since Rails 5.0, need to mimic this to support Rails 4.2.
    # @see https://api.rubyonrails.org/classes/ActionController/Helpers.html#method-i-helpers
    #   ActionController::Helpers#helpers
    # @see https://github.com/rails/rails/blob/5-0-stable/actionpack/lib/action_controller/metal/helpers.rb#L118

    # @!method render_error(exception, symbol)
    # Capture exceptions and display the error using error template.
    # @param exception [Exception]
    # @param symbol [Symbol] http status symbol

    included do # rubocop:disable Metrics/BlockLength
      extend Engineable::ClassMethods
      include Engineable
      include SharedHelpers

      rescue_from NotFound, with: :not_found
      rescue_from ::ActionController::ParameterMissing, with: :bad_request
      rescue_from ::ActiveRecord::StatementInvalid, with: :unprocessable_entity
      rescue_from NotImplemented, with: :not_implemented
      rescue_from UnprocessableEntity, with: :unprocessable_entity

      delegate(*ConfigurationHelper.instance_methods(false), :url_for, to: :helpers)

      # (see #healthy)
      def healthy
        render plain: 'healthy'
      end

      # (see #not_found)
      def not_found(exception = nil)
        render_error exception, __callee__
      end

      # (see #bad_request)
      def bad_request(exception = nil)
        render_error exception, __callee__
      end

      # (see #unprocessable_entity)
      def unprocessable_entity(exception = nil)
        render_error exception, __callee__
      end

      # (see #internal_server_error)
      def internal_server_error(exception = nil)
        render_error exception, __callee__
      end

      # (see #not_implemented)
      def not_implemented(exception = nil)
        render_error exception, __callee__
      end

      # (see #helpers)
      def helpers
        @helpers ||= defined?(super) ? super : view_context
      end

      protected

      # (see #render_error)
      def render_error(exception, symbol)
        Logger.error exception, sourcing: false

        @exception = exception
        @symbol = symbol
        @code = Rack::Utils::SYMBOL_TO_STATUS_CODE[symbol].to_i
        respond_with @exception, status: @code, template: ERROR_PATH, prefixes: _prefixes
      end
    end
  end
end
