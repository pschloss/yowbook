source 'https://rubygems.org'
ruby '2.7.2'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.2.3'
gem 'bcrypt', '3.1.11'
gem 'faker', '~> 1.7', '>= 1.7.1'
gem 'carrierwave', '~> 1.0'
gem 'mini_magick', '~> 4.6'
gem 'validates_timeliness', '~> 4.0'
gem 'friendly_id', '~> 5.2'
gem 'will_paginate', '~> 3.1', '>= 3.1.5'
gem 'will_paginate-bootstrap4', '~> 0.1.2'
gem 'bootstrap', '~> 4.3.1'
gem 'jquery-ui-rails'
gem 'filterrific', '~> 2.1', '>= 2.1.2'
gem 'puma', '~> 3.0'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'jquery-rails', '~> 4.2'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'rails-controller-testing'
gem 'bootstrap-toggle-rails', '~> 2.2', '>= 2.2.1.0'
gem 'loofah', '~>2.3.1'
gem 'bootsnap',  require: false

group :development, :test do
  gem 'sqlite3', '1.3.12'
	gem 'byebug', '9.0.6', 	platform: :mri
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
	gem 'rb-readline', '~> 0.5.3'
end

group :production do
	gem 'pg'
end
