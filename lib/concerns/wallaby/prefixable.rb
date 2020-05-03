# frozen_string_literal: true

module Wallaby
  # Field helper for model decorator
  module Prefixable
    # @return [Array<String>] prefixes
    def wallaby_prefixes
      override_prefixes(
        options: { mapping_actions: Hash.new('form') }
      ) do |prefixes|
        PrefixesBuilder.new(
          prefixes: prefixes,
          resources_name: current_resources_name,
          script_name: request.env[SCRIPT_NAME]
        ).execute

        prefixes[0..prefixes.index(ResourcesController.controller_path)]
      end
    end
  end
end
