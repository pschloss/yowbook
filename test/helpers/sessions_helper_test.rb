require 'test_helper'

class SessionsHelperTest < ActionView::TestCase

	def setup
		@shepherd = shepherds(:michael)
		remember(@shepherd)
	end

  test "current_shepherd returns right shepherd when session is nil" do
    assert_equal @shepherd, current_shepherd
    assert is_logged_in?
	end

	test "current_shepherd returns nil when remember digest is wrong" do
		@shepherd.update_attribute(:remember_digest, Shepherd.digest(Shepherd.new_token))
		assert_nil current_shepherd
	end
end
