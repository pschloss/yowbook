require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
	test "full title helper" do
		assert_equal full_title, "Yowbook"
		assert_equal full_title("Help"), "Help | Yowbook"
	end
end
