module Wallaby
  class Inflector
    def self.classify(name)
      name.gsub(COLONS, SLASH).classify
    end
  end
end
