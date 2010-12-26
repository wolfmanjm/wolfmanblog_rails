# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}


RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  # setup transactional factory for sequel, when running request or model specs
  [:request, :model, :cell, :transactional].each do |type|
    config.around(:each, :type => type) do |example|
      Sequel::DATABASES.first.transaction do
        example.run
        raise Sequel::Error::Rollback
      end
    end
  end

end

# to make factory girl run with sequel
class Sequel::Model
  def save!
    save(:validate=>false)
  end
end
