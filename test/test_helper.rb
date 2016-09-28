ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'


module FixturesAndTestsHelpers
  def to_digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
end
ActiveRecord::FixtureSet.context_class.include FixturesAndTestsHelpers



class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  include FixturesAndTestsHelpers

  # Add more helper methods to be used by all tests here...

  def login_as(user)

    if defined?(post_via_redirect) #i.e. if integration test
      post login_path, session: { email: user.email, password: 'password' }
    else
      session[:user_id] = user.id
    end
  end

  def assert_redirected_with_flash_to(url)
    assert_redirected_to url
    assert_not_nil flash
  end

  def assert_login_required
    assert_redirected_to login_url
    assert_not_nil flash
  end

end
