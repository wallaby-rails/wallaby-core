# frozen_string_literal: true

module Wallaby
  # Model not found error
  class ModelNotFound < NotFound
    # @return [String] not found error message
    def message
      return super if super.include? "\n"

      Locale.t 'errors.not_found.model', model: super
    end
  end
end
