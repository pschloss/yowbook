require 'test_helper'

class ShepherdsSignupTest < ActionDispatch::IntegrationTest

	def setup
		ActionMailer::Base.deliveries.clear
	end

	test "invalid signup information" do
		get signup_path
		assert_no_difference 'Shepherd.count' do
			post shepherds_path, params: { shepherd: {  name: "",
																					username: "foo bar",
																					email: "foo@bar",
																					password: "foo",
 																					password_confirmation: "bar"
																				}
																}
		end
		assert_template 'shepherds/new'
		assert_select "div.field_with_errors"
		assert_select 'div#error_explanation li', count: 5
	end

	test "invalid signup because a reserved username was selected" do
		get signup_path
		assert_no_difference 'Shepherd.count' do
			post shepherds_path, params: { shepherd: {  name: "Foo Bar",
																					username: "help",
																					email: "foo@bar.com",
																					password: "foobar",
 																					password_confirmation: "foobar"
																				}
																}
		end
		assert_template 'shepherds/new'
		assert_select "div.field_with_errors"
		assert_select 'div#error_explanation li', count: 1
	end


	test "valid signup information with account activation" do
		get signup_path
		assert_difference 'Shepherd.count', 1 do
			post shepherds_path, params: { shepherd: {  name: "Example Shepherd",
																					username: "foobar",
																					email:                 "shepherd@example.com",
																					password:              "password",
 																					password_confirmation: "password" } }
		end

		assert_equal 1, ActionMailer::Base.deliveries.size
		shepherd = assigns(:shepherd)
		assert_not shepherd.activated?

		#Try to log in before activation
		log_in_as(shepherd)
		assert_not is_logged_in?

		#Invalid activation token
		get edit_account_activation_path("invalid token", email: shepherd.email)
		assert_not is_logged_in?

		#Valid token, wrong email
		get edit_account_activation_path(shepherd.activation_token, email: "wrong")
		assert_not is_logged_in?

		#Valid activation token
		get edit_account_activation_path(shepherd.activation_token, email: shepherd.email)
		assert shepherd.reload.activated?
		follow_redirect!
		assert_template 'shepherds/show'
		assert is_logged_in?
	end

end
