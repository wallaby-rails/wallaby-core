# frozen_string_literal: true

module Wallaby
  # Guess the associated class for give class
  class Guesser
    SUFFIX = /(Controller|Decorator|Servicer|Authorizer|Paginator)$/.freeze # :no_doc:

    class << self
      # Find out the first demodulized class constant for the give class name.
      # For example, if given class name is **Admin::Order::ItemsController**,
      # then it will try to constantize the following demodulized class names
      # and return the first one that is successfully constantized:
      #
      # - Admin::Order::Item
      # - Order::Item
      # - Item
      # @param class_name [String]
      # @param suffix [String]
      # @param super_class [Class]
      # @param replacement [String]
      # @return [Class] found associated class
      # @return [nil] if not found
      def class_for(class_name, options = {}, &block)
        super_class = options[:super_class]
        suffix = options[:suffix] || EMPTY_STRING
        replacement = options[:replacement] || SUFFIX
        denamespace = options.key?(:denamespace) ? options[:denamespace] : true
        base_name = class_name.gsub(replacement, EMPTY_STRING).singularize << suffix
        possible_class_from(base_name, super_class: super_class, denamespace: denamespace, &block)
        # parts = base_name.split(COLONS)
        # parts.each_with_index do |_, index|
        #   klass = constantize parts[index..-1].join(COLONS)
        #   next unless klass
        #   # check superclass inheritance
        #   next if super_class && klass >= super_class
        #   # additional checking, the given block should return true to continue
        #   next if block_given? && !yield(klass)

        #   return klass
        # end

        # nil
      end

      def possible_class_from(class_name, super_class: nil, denamespace: false)
        parts = denamespace ? class_name.split(COLONS) : [class_name]
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
      # @param class_name [String]
      # @return [Class] if class name is valid
      # @return [nil] otherwise
      def constantize(class_name)
        # NOTE: DO NOT try to use const_defined? and const_get EVER.
        # Using constantize is Rails way to make it require the corresponding file.
        class_name.constantize
      rescue NameError
        yield(class_name) if block_given?
        nil
      end
    end
  end
end
