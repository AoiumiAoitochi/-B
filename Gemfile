source "https://rubygems.org"

ruby "3.1.0"
gem "rails", "~> 7.1.0"
gem 'bcrypt'
gem 'faker'
gem 'bootstrap-sass'
gem "sprockets-rails"
gem "sqlite3", "~> 1.4"
gem "puma", ">= 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem 'will_paginate', '~> 3.3'
gem 'bootstrap-will_paginate', '1.0.0'
gem 'rails-i18n'
gem "tzinfo-data", platforms: %i[ mswin mswin64 mingw x64_mingw jruby ]
gem "bootsnap", require: false


group :development, :test do
  gem "debug", platforms: %i[ mri mswin mswin64 mingw x64_mingw ]
end

group :development do
  gem "web-console"
  gem "error_highlight", ">= 0.4.0", platforms: [:ruby]
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end

group :production do
  gem 'pg', '~> 1.2'
end
