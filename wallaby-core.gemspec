# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'wallaby/core/version'

Gem::Specification.new do |spec|
  spec.name          = 'wallaby-core'
  spec.version       = Wallaby::Core::VERSION
  spec.authors       = ['Tian Chen']
  spec.email         = ['me@tian.im']
  spec.license       = 'MIT'

  spec.summary       = 'The core of Wallaby'
  spec.description   = spec.summary
  spec.homepage      = 'https://github.com/wallaby-rails/wallaby-core'

  spec.metadata = {
    'homepage_uri' => spec.homepage,
    'source_code_uri' => spec.homepage,
    'changelog_uri' => "#{spec.homepage}/blob/master/CHANGELOG.md"
  }

  spec.files = Dir[
    '{app,lib,config}/**/*',
    'LICENSE',
    'README.md'
  ]

  spec.add_dependency 'activemodel', '>= 4.2.0'
  spec.add_dependency 'railties', '>= 4.2.0'

  spec.add_dependency 'parslet'
  spec.add_dependency 'responders'
  spec.add_dependency 'wallaby-view', '~> 0.1.2'

  spec.add_development_dependency 'rspec-rails'
  spec.add_development_dependency 'wallaby-cop'
end
