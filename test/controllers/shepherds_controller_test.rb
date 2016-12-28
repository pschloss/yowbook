require 'test_helper'

class ShepherdsControllerTest < ActionDispatch::IntegrationTest

	def setup
		@shepherd = shepherds(:michael)
		@other_shepherd = shepherds(:archer)
	end

	test "should redirect index when not logged in" do
		get shepherds_path
		assert_redirected_to login_url
	end

  test "should get new" do
    get signup_path
    assert_response :success
  end

	test "should redirect edit when not logged in" do
		get edit_shepherd_path(@shepherd)
		assert_not flash.empty?
		assert_redirected_to login_url
	end

	test "should redirect update when not logged in" do
		patch shepherd_path(@shepherd), params: { shepherd: { name: @shepherd.name,
																							email: @shepherd.email } }

		assert_not flash.empty?
		assert_redirected_to login_url
	end

  test "should redirect edit when logged in as wrong shepherd" do
    log_in_as(@other_shepherd)
    get edit_shepherd_path(@shepherd)
    assert !flash.empty?
	  assert_redirected_to root_url
	end

	test "should redirect update when logged in as wrong shepherd" do
	  log_in_as(@other_shepherd)
	  patch shepherd_path(@shepherd), params: { shepherd: { name: @shepherd.name, email: @shepherd.email } }
	  assert !flash.empty?
	  assert_redirected_to root_url
	end

	test "should not allow the admin attribute to be edited via the web" do
		log_in_as(@other_shepherd)
		assert_not @other_shepherd.admin?
		patch shepherd_path(@other_shepherd), params: {
																		shepherd: { password:              'password',
																						password_confirmation: 'password',
																						admin: true } }
		assert_not @other_shepherd.reload.admin?
	end

	test "should redirect destroy when not logged in" do
		assert_no_difference 'Shepherd.count' do
			delete shepherd_path(@shepherd)
		end
		assert_redirected_to login_url
	end

	test "should redirect destroy when logged in as a non-admin" do
		log_in_as(@other_shepherd)
		assert_no_difference 'Shepherd.count' do
				delete shepherd_path(@shepherd)
		end
		assert_redirected_to root_url
	end

	test "should delete shepherd when logged in as a admin" do
		log_in_as(@shepherd)
		assert_difference 'Shepherd.count', -1 do
				delete shepherd_path(@other_shepherd)
		end
	end

end
