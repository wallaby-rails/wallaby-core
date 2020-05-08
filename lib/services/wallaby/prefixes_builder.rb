# frozen_string_literal: true

module Wallaby
  # To extend prefixes to provide more possibility
  class PrefixesBuilder
    include ActiveModel::Model

    attr_accessor :prefixes
    attr_accessor :resources_name
    attr_accessor :script_name

    def execute
      return if prefixes.include? resources_path

      full_prefix = [script_path, resources_path].compact.join(SLASH)

      return if full_prefix.blank? || prefixes.include?(full_prefix)

      prefixes.insert 0, full_prefix
    end

    private

    def resources_path
      @resources_path ||= resources_name.try :gsub, COLONS, SLASH
    end

    def script_path
      @script_path ||= script_name.try :[], 1..-1
    end
  end
end
