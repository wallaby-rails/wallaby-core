# frozen_string_literal: true

module Wallaby
  class Custom
    # Default authorization provider for {Custom} mode that whitelists everything.
    class DefaultProvider < DefaultAuthorizationProvider
    end
  end
end
