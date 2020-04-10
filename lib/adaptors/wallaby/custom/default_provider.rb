# frozen_string_literal: true

module Wallaby
  class Custom
    # Default authorization provider for {Wallaby::Custom} mode that whitelists everything.
    class DefaultProvider < DefaultAuthorizationProvider
    end
  end
end
