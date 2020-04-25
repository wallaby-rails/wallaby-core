# frozen_string_literal: true

module Wallaby
  # Configurable related class methods
  module Configurable
    # Configurable related class methods
    module ClassMethods
      # authentication related
      begin
        # @!attribute [r] logout_path
        def logout_path
          @logout_path ||= superclass.try :logout_path
        end

        # @!attribute [w] logout_path
        attr_writer :logout_path

        # @!attribute [r] logout_method
        def logout_method
          @logout_method ||= superclass.try :logout_method
        end

        # @!attribute [w] logout_method
        attr_writer :logout_method

        # @!attribute [r] email_method
        def email_method
          @email_method ||= superclass.try :email_method
        end

        # @!attribute [w] email_method
        attr_writer :email_method
      end
    end
  end
end
