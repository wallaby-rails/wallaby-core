# frozen_string_literal: true

module Wallaby
  # Custom logger
  module Logger
    class << self
      %w(unknown fatal error warn info debug).each do |method_id|
        define_method method_id do |message, replacements = {}|
          message = message.inspect unless message.is_a? String
          sourcing = replacements.delete :sourcing # sourcing can be set to false

          from = "\nfrom #{caller[sourcing || 0]}" unless sourcing == false
          Rails.logger.public_send(
            method_id, "#{method_id.upcase}: #{format message, replacements}#{from}"
          )
          nil
        end
      end
    end
  end
end
