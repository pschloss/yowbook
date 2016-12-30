class RelationshipsController < ApplicationController
	before_action :logged_in_shepherd

	def create
		@shepherd = Shepherd.find(params[:followed_id])
		current_shepherd.follow(@shepherd)
		respond_to do |format|
			format.html { redirect_to @shepherd }
			format.js
		end
	end

	def destroy
		@shepherd = Relationship.find(params[:id]).followed
		current_shepherd.unfollow(@shepherd)
		respond_to do |format|
			format.html { redirect_to @shepherd }
			format.js
		end
	end

end
