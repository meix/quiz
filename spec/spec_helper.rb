require 'spork'
#uncomment the following line to use spork with the debugger
#require 'spork/ext/ruby-debug'

# Fake sidekiq test
# require 'sidekiq/testing'
# Sidekiq::Testing.fake!

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
#require 'rspec/autorun'

Spork.prefork do
  RSpec.configure do |config|

    # If you're not using ActiveRecord, or you'd prefer not to run each of your
    # examples within a transaction, remove the following line or assign false
    # instead of true.
    config.use_transactional_fixtures = true
    # warning old `:should`  new `:expect`
    config.mock_with :rspec do |mocks|
      mocks.syntax =  [:should, :expect]
    end

    config.expect_with :rspec do |expectations|
      expectations.syntax = [:should, :expect]
    end

    config.include RSpec::Rails::RequestExampleGroup, file_path: /spec\/api/

    config.include FactoryGirl::Syntax::Methods
  end
end

Spork.each_run do
  FactoryGirl.reload
  Dir["#{Rails.root}/app/**/**/**/*.rb"].each do |file|
    load file
  end
end
