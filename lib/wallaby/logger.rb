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
          Wallaby.configuration.logger.try(
            method_id,
            "#{heading}#{method_id.to_s.upcase}: #{format new_message, replacements}#{from}"
          )
          nil
        end
      end

      # @param key [Symbol,String]
      # @param message_or_config [String, false]
      # @param replacements [Hash]
      # @example to disable a particular hint message:
      #   Wallaby::Logger.hint(:customize_controller, false)
      def hint(key, message_or_config, replacements = {})
        @hint ||= {}
        return @hint[key] = false if message_or_config == false
        return if @hint[key] == false || !message_or_config.is_a?(String)

        new_message = <<~MESSAGE
          #{message_or_config}
          If you don't want to see this kind of message again, you can disable it in `config/initializers/wallaby.rb`:

            Wallaby::Logger.hint(#{key.inspect}, false)
        MESSAGE
        debug(new_message, replacements)
      end

      protected

      # @param message [String,StandardError,Object]
      # @param sources [Array<String>] array of files
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
