source 'http://rubygems.org'

gem 'rails', '3.1.3'
gem 'sqlite3'

gem 'haml-rails'
gem "formtastic", "~> 2.0.2"
gem 'formtastic-bootstrap'
gem 'rails3-jquery-autocomplete'
gem 'cocoon'
gem 'kaminari'
gem 'rails_autolink'
gem 'acts-as-taggable-on'
gem 'carrierwave'
gem 'RedCloth'
gem 'settingslogic'
gem 'coffeebeans'

gem 'squeel'

gem 'sunspot_rails'
gem 'sunspot_solr'
gem 'sunspot_test'
gem 'progress_bar'

gem 'activeadmin', '0.4.0'
gem 'meta_search',  '>= 1.1.0.pre'

gem 'omniauth'
gem 'omniauth-twitter'
gem 'omniauth-facebook'
gem 'twitter'
gem 'fb_graph'

unless RUBY_PLATFORM =~ /darwin/i 
  gem 'execjs' 
  gem 'therubyracer'
end

gem 'capistrano'

gem 'sass-rails',   '3.1.4'
# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'coffee-rails', '~> 3.1.1'
  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

gem 'ruby-debug19', :require => 'ruby-debug'

group :development, :test do
  gem 'rspec-rails'
  gem 'capybara'
  gem 'rb-fsevent', :require => false if RUBY_PLATFORM =~ /darwin/i
  gem 'growl_notify' if RUBY_PLATFORM =~ /darwin/i
  gem 'guard-rspec'
  gem 'guard-spork'
  gem 'faker'
  gem 'fabrication'
  gem 'tapp'
  gem 'i18n_generators'
end

group :production do
#  gem 'mysql2', '0.2.7'
  gem 'mysql2', :git => 'git://github.com/brianmario/mysql2.git'
end
