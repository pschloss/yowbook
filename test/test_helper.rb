ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
	include ApplicationHelper

	def is_logged_in?
		!session[:shepherd_id].nil?
	end

	def log_in_as(shepherd)
		session[:shepherd_id] = shepherd.id
	end

end


class ActionDispatch::IntegrationTest

	# def log_in_as(shepherd, password: 'password', remember_me: '1')
	# 	post login_path, params: { session: { email: shepherd.email,
	# 																				password: password,
	# 																				remember_me: remember_me } }
	# end

  def log_in_as(shepherd, password: 'password', remember_me: '1')
    post login_path, params: { session: { login: shepherd.email,
																					password: password,
																					remember_me: remember_me } }
 	end

end
