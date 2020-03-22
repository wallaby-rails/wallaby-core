# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## TODOs

- change to all lables to be prefixed with controller/name

## [0.2.1](https://github.com/wallaby-rails/wallaby-core/releases/tag/0.2.1) - 2020-03-24

### Added

- feat: better logger to output more information including the caller ([#18](https://github.com/wallaby-rails/wallaby-core/pull/18))
- chore: rename Utils.t to Locale.t ([#17](https://github.com/wallaby-rails/wallaby-core/pull/17))
- feat: put all translation under wallaby namespace and use custom translator method ([#16](https://github.com/wallaby-rails/wallaby-core/pull/16))

### Changed

- chore: ensure layout is set and not impacted by ApplicationController's layout ([#15](https://github.com/wallaby-rails/wallaby-core/pull/15))
- chore: only define Ability when CanCan exists ([#14](https://github.com/wallaby-rails/wallaby-core/pull/14))
- chore: extract everything into a concern for ResourcesController ([#13](https://github.com/wallaby-rails/wallaby-core/pull/13))
- chore: use simplecov 0.17 for codeclimate report ([#12](https://github.com/wallaby-rails/wallaby-core/pull/12))

## [0.2.0](https://github.com/wallaby-rails/wallaby-core/releases/tag/0.2.0) - 2020-02-14

### Changed

- chore: remove number rule from Wallaby::Parser ([#11](https://github.com/wallaby-rails/wallaby-core/pull/11))
- feat: handle basic data type for colon query ([#9](https://github.com/wallaby-rails/wallaby-core/pull/9))
- chore: use `wallaby-view` gem ([#8](https://github.com/wallaby-rails/wallaby-core/pull/8))
- fix: Wallaby::PreloadUtils#eager_load_paths for Pathname objects ([#7](https://github.com/wallaby-rails/wallaby-core/pull/7))

## [0.1.2](https://github.com/wallaby-rails/wallaby-core/releases/tag/0.1.2) - 2019-12-17

### Changed

- fix: make cell utils to work with path that starts with /app/vendor ([#6](https://github.com/wallaby-rails/wallaby-core/pull/6))

## [0.1.1](https://github.com/wallaby-rails/wallaby-core/releases/tag/0.1.1) - 2019-12-11

### Changed

- fix: same options being used for multiple index_link ([#5](https://github.com/wallaby-rails/wallaby-core/pull/5))
- chore: test_files and require_paths shouldn't be included in the gemspec ([#4](https://github.com/wallaby-rails/wallaby-core/pull/4))

## [0.1.0](https://github.com/wallaby-rails/wallaby-core/releases/tag/0.1.0) - 2019-12-05

### Added

- feat: support Rails 6 ([#3](https://github.com/wallaby-rails/wallaby-core/pull/3))
