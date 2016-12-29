class RelationshipsController < ApplicationController
	before_action :logged_in_shepherd

	def create
		shepherd = Shepherd.find(params[:followed_id])
		current_shepherd.follow(shepherd)
		redirect_to shepherd
	end

	def destroy
		shepherd = Relationship.find(params[:id]).followed
		current_shepherd.unfollow(shepherd)
		redirect_to shepherd
	end

end
