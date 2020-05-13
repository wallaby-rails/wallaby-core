# frozen_string_literal: true

module Wallaby
  # Guess the associated class for give class
  class Guesser
    SUFFIX = /(Controller|Decorator|Servicer|Authorizer|Paginator)$/.freeze # :no_doc:

    class << self
      # Guess the associated class for give class. For example, if given class is **Admin::Order::ItemsController**,
      # then it will try to constantize the following class name
      # and return the first one that is successfully constantized:
      #
      # - Admin::Order::Item
      # - Order::Item
      # - Item
      # @param class_name [String]
      # @param suffix [String]
      # @param super_class [Class]
      # @return [Class] found associated class
      # @return [nil] if not found
      def class_for(
        class_name, suffix: EMPTY_STRING, super_class: nil
      )
        base_name = class_name.gsub(SUFFIX, EMPTY_STRING).singularize << suffix
        parts = base_name.split COLONS
        parts.each_with_index do |_, index|
          klass = constantize parts[index..-1].join(COLONS)
          next unless klass
          # check superclass inheritance
          next if super_class && klass >= super_class
          # additional checking, the given block should return true to continue
          next if block_given? && !yield(klass)

          return klass
        end

        nil
      end

      protected

      # Constantize the class name
      # @return [Class] if class name is valid
      # @return [nil] otherwise
      def constantize(class_name)
        # NOTE: DO NOT try to use const_defined? and const_get EVER.
        # Using constantize is Rails way to make it require the corresponding file.
        class_name.constantize
      rescue NameError # rubocop:disable Lint/SuppressedException
      end
    end
  end
end
