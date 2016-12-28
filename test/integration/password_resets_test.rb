require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest

	def setup
		ActionMailer::Base.deliveries.clear
		@shepherd = shepherds(:michael)
	end

	test "password resets" do
		get new_password_reset_path
		assert_template 'password_resets/new'

		#invalid email
		post password_resets_path, params: { password_reset: { email: "" } }
		assert_not flash.empty?
		assert_template 'password_resets/new'

		#valid email
		post password_resets_path,
				params: { password_reset: { email: @shepherd.email } }
		assert_not_equal @shepherd.reset_digest, @shepherd.reload.reset_digest
		assert_equal 1, ActionMailer::Base.deliveries.size
		assert_not flash.empty?
		assert_redirected_to root_url

		#password reset form
		shepherd = assigns(:shepherd)

		#wrong email
		get edit_password_reset_path(shepherd.reset_token, email: "")
		assert_redirected_to root_url

		#inactive shepherd
		shepherd.toggle!(:activated)
		get edit_password_reset_path(shepherd.reset_token, email: shepherd.email)
		assert_redirected_to root_url
		shepherd.toggle!(:activated)

		#right email, wrong token
		get edit_password_reset_path('wrong token', email: shepherd.email)
		assert_redirected_to root_url

		#right email, right token
		get edit_password_reset_path(shepherd.reset_token, email: shepherd.email)
		assert_template 'password_resets/edit'
		assert_select "input[name=email][type=hidden][value=?]", shepherd.email

		#invalid password and confirmation
		patch password_reset_path(shepherd.reset_token),
					params: { email: shepherd.email,
										shepherd: { password:              "foo",
														password_confirmation: "bar" } }
		assert_select 'div#error_explanation'

		#empty password
		patch password_reset_path(shepherd.reset_token),
					params: { email: shepherd.email,
										shepherd: { password:              "",
														password_confirmation: "" } }
		assert_select 'div#error_explanation'

		#valid password and confirmation
		patch password_reset_path(shepherd.reset_token),
					params: { email: shepherd.email,
										shepherd: { password:              "foobaz",
														password_confirmation: "foobaz" } }
		assert is_logged_in?
		assert_not flash.empty?
		assert_redirected_to shepherd
    assert_nil shepherd.reload.reset_digest

	end

	test "expired token" do
		get new_password_reset_path
		post password_resets_path,
					params: { password_reset: { email: @shepherd.email } }
		@shepherd = assigns(:shepherd)

		@shepherd.update_attribute(:reset_sent_at, 3.hours.ago)
		patch password_reset_path(@shepherd.reset_token),
					params: { email: @shepherd.email,
										shepherd: { password:              "foobaz",
														password_confirmation: "foobaz" } }
		assert_response :redirect
		follow_redirect!
		assert_match /Password reset has expired/i, response.body

	end

end
