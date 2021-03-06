require 'test_helper'

class ShepherdsEditTest < ActionDispatch::IntegrationTest

	def setup
		@shepherd = shepherds(:michael)
	end

	test "unsuccessful edit" do
		log_in_as(@shepherd)
		get edit_shepherd_path(@shepherd)
		assert_template 'shepherds/edit'
		patch shepherd_path(@shepherd), params: { shepherd: { name: "",
																							username: "",
																							email: "foo@invalid",
																							password: "foo",
																							password_confirmation: "bar" } }
		assert_template 'shepherds/edit'
		assert_select 'div#error_explanation li', count: 5
	end

	test "successful edit with friendly forwarding" do
		get edit_shepherd_path(@shepherd)
		log_in_as(@shepherd)
		assert_redirected_to edit_shepherd_path(@shepherd)

		get edit_shepherd_path(@shepherd)
		assert_template 'shepherds/edit'
		name = "Foo Bar"
		username = "foobar"
		email = "foo@bar.com"
		patch shepherd_path(@shepherd), params: { shepherd: { name: name,
																							username: username,
																							email: email,
																							password: "",
																							password_confirmation: "" } }
		assert_not flash.empty?
		@shepherd.reload
		assert_redirected_to @shepherd
		assert_equal name, @shepherd.name
		assert_equal username, @shepherd.username
		assert_equal email, @shepherd.email
	end

end
