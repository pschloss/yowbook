require 'test_helper'

class ShepherdsProfileTest < ActionDispatch::IntegrationTest
	include ApplicationHelper

	def setup
		@shepherd = shepherds(:michael)
	end

	test "profile dislpay" do
    log_in_as(@shepherd)
		get shepherd_path(@shepherd)
		assert_template 'shepherds/show'
		assert_select 'title', full_title("#{@shepherd.name} (@#{@shepherd.username})")
		assert_select 'h1', text: @shepherd.name
		assert_select 'h1>img.gravatar'
		assert_match @shepherd.animals.count.to_s, response.body
		assert_select 'div.pagination'
		@shepherd.animals.paginate(page: 1).each do |animal|
			assert_match animal.eartag, response.body
		end
	end


  test "test profile stats on home page" do
    log_in_as(@shepherd)
    get root_path(@shepherd)
    assert_template 'static_pages/home'
    assert_select 'div.stats', count: 1
    assert_match @shepherd.following.count.to_s, response.body
    assert_match @shepherd.followers.count.to_s, response.body
  end

end
