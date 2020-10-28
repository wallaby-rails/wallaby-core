# frozen_string_literal: true

module Wallaby
  # A simple wrapper so that all fields (index/show/form) can be set in one-line.
  #
  # @example set type for name to `'string'` in decorator
  #   class ProductDecorator < ApplicationDecorator
  #     all_fields[:name][:type] = 'string'
  #   end
  class AllFields
    def initialize(decorator)
      @decorator = decorator
      @keys = []
    end

    # @param key [Symbol, String]
    # @return [AllFields] self
    def [](key)
      @keys << key
      self
    end

    # Set value for given keys
    # @param last_key [Symbol, String]
    # @param value [Object]
    # @return [Object] value
    def []=(last_key, value)
      %i(index_fields show_fields form_fields).each do |fields|
        last = @keys.reduce(@decorator.try(fields)) do |metadata, key|
          metadata.try :[], key
        end
        last.try :[]=, last_key, value
      end

      @keys = []
      value # rubocop:disable Lint/Void
    end
  end
end
