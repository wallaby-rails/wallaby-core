# frozen_string_literal: true

module Wallaby
  # Field helper for model decorator
  module Prefixable
    MAPPING_ACTIONS = {
      new: 'form',
      create: 'form',
      edit: 'form',
      update: 'form'
    }.freeze
    # @return [Array<String>] prefixes
    def wallaby_prefixes
      override_prefixes(
        options: { mapping_actions: MAPPING_ACTIONS }
      ) do |prefixes|
        PrefixesBuilder.new(
          controller_class: self.class,
          prefixes: prefixes,
          resources_name: current_resources_name,
          script_name: request.env[SCRIPT_NAME]
        ).execute
      end
    end
  end
end
