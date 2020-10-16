# frozen_string_literal: true

module Wallaby
  # Custom logger
  module Logger
    class << self
      %i(unknown fatal error warn info debug).each do |method_id|
        define_method method_id do |message, replacements = {}|
          sourcing = replacements.delete(:sourcing) # sourcing can be set to false
          heading = replacements.delete(:heading) || 'WALLABY '
          new_message, from = normalize(
            message, sourcing != false && Array(caller[sourcing || 0]) || nil
          )
          Rails.logger.try(
            method_id,
            "#{heading}#{method_id.to_s.upcase}: #{format new_message, replacements}#{from}"
          )
          nil
        end
      end

      def hint(message, replacements = {})
        debug(message, replacements)
      end

      protected

      # @param message [Object]
      def normalize(message, sources)
        case message
        when String
          [message, sources && "\nfrom #{sources.join("     \n")}"]
        when StandardError
          [message.message, sources && "\n#{message.backtrace.join("\n")}"]
        else
          [message.inspect, sources && "\nfrom #{sources.join("     \n")}"]
        end
      end
    end
  end
end
