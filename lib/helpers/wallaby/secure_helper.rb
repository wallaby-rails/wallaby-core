# frozen_string_literal: true

module Wallaby
  # Secure helper
  module SecureHelper
    # Image portrait for given user.
    #
    # - if email is present, a gravatar image tag will be returned
    # - otherwise, an user icon will be returned
    # @param user [Object]
    # @param method_name [Symbol, String]
    # @return [String] IMG or I element
    def user_portrait(user: wallaby_user, method_name: controller.class.try(:email_method))
      # TODO: remove this from 0.3
      method_name ||= security.email_method
      method_name ||= user.methods.grep(/email/i).first || :email
      email = user.try method_name
      return fa_icon 'user' if email.blank?

      image_tag(
        "#{request.protocol}www.gravatar.com/avatar/#{::Digest::MD5.hexdigest email.downcase}",
        class: 'user'
      )
    end

    # Logout path for given user
    # @see Wallaby::Configuration::Security#logout_path
    # @param user [Object]
    # @param app [Object]
    # @param method_name [Symbol, String]
    # @return [String] URL to log out
    def logout_path(user: wallaby_user, app: main_app, method_name: controller.class.try(:logout_path))
      # TODO: remove this from 0.3
      method_name ||= security.logout_path
      method_name ||=
        if defined? ::Devise
          scope = ::Devise::Mapping.find_scope! user
          "destroy_#{scope}_session_path"
        end
      app.try method_name if method_name
    end

    # Logout method for given user
    # @see Wallaby::Configuration::Security#logout_method
    # @param user [Object]
    # @param http_method [Symbol, String]
    # @return [String, Symbol] http method to log out
    def logout_method(user: wallaby_user, http_method: controller.class.try(:logout_method))
      # TODO: remove this from 0.3
      http_method ||= security.logout_method
      http_method ||
        if defined? ::Devise
          scope = ::Devise::Mapping.find_scope! user
          mapping = ::Devise.mappings[scope]
          mapping.sign_out_via
        end
    end
  end
end
