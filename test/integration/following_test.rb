require 'test_helper'

class FollowingTest < ActionDispatch::IntegrationTest

	def setup
		@shepherd = shepherds(:michael)
		@other = shepherds(:archer)
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

	test "should follow a shepherd the standard way" do
		assert_difference '@shepherd.following.count', 1 do
			post relationships_path, params: { followed_id: @other.id }
		end
	end

	test 'should follow a shepherd with Ajax' do
		assert_difference '@shepherd.following.count', 1 do
			post relationships_path, xhr: true, params: { followed_id: @other.id }
		end
	end

	test "should unfollow a shepherd the standard way" do
		@shepherd.follow(@other)
		relationship = @shepherd.active_relationships.find_by(followed_id: @other.id)
		assert_difference '@shepherd.following.count', -1 do
			delete relationship_path(relationship)
		end
	end

	test "should unfollow a shepherd with Ajax" do
		@shepherd.follow(@other)
		relationship = @shepherd.active_relationships.find_by(followed_id: @other.id)
		assert_difference '@shepherd.following.count', -1 do
			delete relationship_path(relationship), xhr: true
		end
	end
end
