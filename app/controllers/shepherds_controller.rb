class ShepherdsController < ApplicationController
	before_action :logged_in_shepherd, only: [:index, :edit, :update, :destroy,
																						:followers, :following]
	before_action :correct_shepherd,   only: [:edit, :update]
	before_action :admin_shepherd,     only: :destroy

	def index
		@shepherds = Shepherd.where("activated = :activated and id != :current_id", { activated: true, current_id: current_shepherd.id }).paginate(page: params[:page])
	end


	def show
		@shepherd = Shepherd.friendly.find(params[:id])
		redirect_to root_url and return unless @shepherd.activated
		@new_animal = current_shepherd.animals.build if logged_in?
		@animals = @shepherd.animals.paginate(page: params[:page], per_page: 25)
	end

  def new
		@shepherd = Shepherd.new
  end

	def create
		@shepherd = Shepherd.new(shepherd_params)
		if @shepherd.save
			@shepherd.send_activation_email
			flash[:info] = "Please check your email to activate your account"
			redirect_to root_url
		else
			render 'new'
		end
	end

	def edit
		@shepherd = Shepherd.friendly.find(params[:id])
	end

	def update
		@shepherd = Shepherd.friendly.find(params[:id])

		if @shepherd.update_attributes(shepherd_params)
			flash[:success] = "Profile updated"
			redirect_to @shepherd
		else
			render 'edit'
		end
	end

	def destroy
		Shepherd.friendly.find(params[:id]).destroy
		flash[:success] = "Shepherd deleted"
		redirect_to shepherds_url
	end

	def following
		#needs to set a title, find the user, retrieve either @user.following
		@title = "Following"
		@shepherd = Shepherd.friendly.find(params[:id])
		@shepherds = @shepherd.following.paginate(page: params[:page])
		render 'show_follow'
	end

	def followers
		#needs to set a title, find the user, retrieve either @user.following
		@title = "Followers"
		@shepherd = Shepherd.friendly.find(params[:id])
		@shepherds = @shepherd.followers.paginate(page: params[:page])
		render 'show_follow'
	end

	private
		def shepherd_params
			params.require(:shepherd).permit(:name, :username, :email, :password, :password_confirmation)
		end


		#Before filters

		#Confirms the correct shepherd
		def correct_shepherd
			@shepherd = Shepherd.friendly.find(params[:id])
			redirect_to(root_url) unless current_shepherd?(@shepherd)
		end

		def admin_shepherd
			redirect_to(root_url) unless current_shepherd.admin?
		end
end
