require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

	test "invalid signup information" do
		get signup_path
		assert_no_difference 'User.count' do
			post users_path, params: { user: {  name: "",
																					email: "foo@bar",
																					password: "foo",
 																					password_confirmation: "bar"
																				}
																}
		end
		assert_template 'users/new'
		assert_select "div#error_explanation li", count: 4
	end

	test "valid signup information" do
		get signup_path
		assert_difference 'User.count', 1 do
			post users_path, params: { user: {  name: "Example User",
																					email: "foo@bar.org",
																					password: "foobar",
 																					password_confirmation: "foobar"
																				}
																}
		end
		follow_redirect!
		assert_template 'users/show'
		assert_select "div.alert-success", count: 1
		assert is_logged_in?
	end

end
