require 'test_helper'

class ShepherdsProfileTest < ActionDispatch::IntegrationTest
	include ApplicationHelper

	def setup
		@shepherd = shepherds(:michael)
		@other_shepherd = shepherds(:archer)
	end

	test "shepherd's profile dislpay" do
    log_in_as(@shepherd)
		get shepherd_path(@shepherd)
		assert_template 'shepherds/show'
		assert_select 'title', full_title("#{@shepherd.name} (@#{@shepherd.username})")
		assert_select 'img.gravatar'
		assert_select 'h1', text: @shepherd.name
		assert_match @shepherd.animals.count.to_s, response.body
		assert_select 'nav.pagination'
		@shepherd.animals.paginate(page: 1, per_page: 25).each do |animal|
			# $stdout.print "#{animal.eartag}\n"
			assert_match animal.eartag, response.body
		end

		get shepherd_path(@other_shepherd)
		assert_template 'shepherds/show'

	end


  test "test profile stats on current_shepherd's page" do
    log_in_as(@shepherd)
    get root_path(@shepherd)
		follow_redirect!
    assert_template 'shepherds/show'
    assert_select 'div.stats', count: 1
    assert_match @shepherd.following.count.to_s, response.body
    assert_match @shepherd.followers.count.to_s, response.body
  end

end
