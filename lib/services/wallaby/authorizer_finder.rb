module Wallaby
  class AuthorizerFinder < DecoratorFinder
    def execute
      controller_class.model_authorizer ||
      possible_default_class ||
      controller_class.application_authorizer
    end
  end
end
