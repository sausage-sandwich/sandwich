# frozen_string_literal: true

source 'https://rubygems.org'

gem 'aasm'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 4.3'
gem 'rails', '~> 6.1'
gem 'sass-rails', '>= 6'
gem 'webpacker'

gem 'bcrypt', '~> 3.1.7'
gem 'bootstrap', '~> 5.0.1'
gem 'honeybadger'
gem 'hotwire-rails'
gem 'interactor'
gem 'jbuilder', '~> 2.7'
gem 'kaminari'
gem 'redis'
gem 'russian'
gem 'shrine'
gem 'slim'
gem 'sprockets-rails', require: 'sprockets/railtie'
gem 'stimulus-rails'
gem 'turbo-rails'

gem 'image_processing', '~> 1.12'

gem 'bootsnap', '>= 1.4.2', require: false

group :development, :test do
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'pry-byebug'
  gem 'rspec-rails'
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
end

group :test do
  gem 'database_cleaner-active_record'
end

group :development do
  gem 'capistrano', require: false
  gem 'capistrano3-puma', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rbenv', require: false
  gem 'listen', '~> 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
