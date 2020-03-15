# frozen_string_literal: true

module Wallaby
  # Resource not found error
  class ResourceNotFound < NotFound
    # @return [String] resource not found error message
    def message
      Utils.t 'errors.not_found.resource', resource: super
    end
  end
end
