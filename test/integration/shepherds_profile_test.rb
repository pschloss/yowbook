require 'test_helper'

class ShepherdsProfileTest < ActionDispatch::IntegrationTest
	include ApplicationHelper

	def setup
		@shepherd = shepherds(:michael)
	end

	test "profile dislpay" do
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
end
