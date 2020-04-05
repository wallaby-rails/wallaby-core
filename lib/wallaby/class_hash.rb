# frozen_string_literal: true

module Wallaby
  # This is a constant-safe hash that stores Class key/value as String
  # and returns value as Class if it was a Class.
  #
  # It can be used for global methods (e.g. {Wallaby::Map.mode_map}) which cache the computed result,
  # so that when Rails reloads, it won't complain that old Class constants still exist in
  # ObjectSpace (see https://github.com/wallaby-rails/wallaby/issues/181).
  #
  # ```
  # A copy of SupportAdmin::ApplicationAuthorizer has been removed from the module tree but is still active!
  # ```
  #
  # As there won't be any Class constants being stored, they will converted to String in {#internal} Hash.
  class ClassHash
    # @!attribute [r] internal
    # @return [Hash] The hash to store Class keys/values as String.
    attr_reader :internal

    # @param [Hash] hash
    def initialize(hash = {})
      @internal =
        (hash || {})
        .transform_keys(&method(:to_class_name))
        .transform_values(&method(:to_class_name))
    end

    # @!attribute [r] origin
    # @return [Hash] The original hash.
    def origin
      # NOTE: DO NOT cache it by using instance variable!
      @internal
        .transform_keys(&method(:to_class))
        .transform_values(&method(:to_class))
        .reject { |k, v| k.nil? || v.nil? }
    end

    # @!method keys
    # Return the keys of {#origin}.
    delegate :keys, to: :origin

    # @!method values
    # Return the values of {#origin}.
    delegate :values, to: :origin

    # @!method ==(other)
    # Compare #{origin} with other.
    delegate :==, to: :origin

    # Save the key/value to the {#internal} hash, and convert the Class key/value to String
    def []=(key, value)
      @internal[to_class_name(key)] = to_class_name(value)
    end

    # Return the value for the given key, and convert the value back to Class if it was a Class
    def [](key)
      to_class @internal[to_class_name(key)]
    end

    # @param other [Hash]
    # @return [Wallaby::ClassHash] new Class hash
    def merge(other)
      self.class.new origin.merge(other.try(:origin) || other)
    end

    # @return [Wallaby::ClassHash] new Class hash
    def select(&block)
      self.class.new origin.select(&block)
    end

    # Ensure to freeze the {#internal}
    # @return [Wallaby::ClassHash] self
    def freeze
      @internal.freeze
      super
    end

    protected

    # Convert to Class name
    def to_class_name(klass)
      klass.is_a?(Class) ? [klass.name, true] : [klass, false]
    end

    # Convert to Class
    def to_class(pair)
      val, is_class = pair
      is_class ? val.constantize : val
    rescue NameError
      Logger.error "`#{val}` is not a valid Class name."
    end
  end
end
