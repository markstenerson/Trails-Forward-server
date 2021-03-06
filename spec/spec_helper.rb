require 'rubygems'
require 'spork'
require 'simplecov'
SimpleCov.start

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However, 
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.

  # This file is copied to spec/ when you run 'rails generate rspec:install'
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'config'

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  ActiveSupport::Dependencies.clear
end

Spork.each_run do
  # This code will be run each time you run your specs.
  Dir.glob("#{Rails.root}/app/models/**/*.rb").sort.each { |file| load file }

  DatabaseCleaner.strategy = :truncation
  DatabaseCleaner.clean
end
