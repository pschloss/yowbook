require 'test_helper'

class FollowingTest < ActionDispatch::IntegrationTest

	def setup
		@shepherd = shepherds(:michael)
		log_in_as(@shepherd)
	end

	test "following page" do
		get following_shepherd_path(@shepherd)
		assert_not @shepherd.following.empty?
		assert_match @shepherd.following.count.to_s, response.body
		@shepherd.following.each do |shepherd|
			assert_select "a[href=?]", shepherd_path(shepherd)
		end
	end

	test "followers page" do
		get followers_shepherd_path(@shepherd)
		assert_not @shepherd.followers.empty?
		assert_match @shepherd.following.count.to_s, response.body
		@shepherd.followers.each do |shepherd|
			assert_select "a[href=?]", shepherd_path(shepherd)
		end
	end

end
