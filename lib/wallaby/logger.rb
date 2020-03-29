# frozen_string_literal: true

module Wallaby
  # Custom logger
  module Logger
    class << self
      %i(unknown fatal error warn info debug deprecated).each do |method_id|
        define_method method_id do |message, replacements = {}|
          message = message.inspect unless message.is_a? String
          sourcing = replacements.delete :sourcing # sourcing can be set to false

          from = "\nfrom #{Array(caller[sourcing || 0]).join("     \n")}" unless sourcing == false
          Rails.logger.public_send(
            method_id == :deprecated ? :warn : method_id,
            "WALLABY #{method_id.to_s.upcase}: #{format message, replacements}#{from}"
          )
          nil
        end
      end
    end
  end
end
