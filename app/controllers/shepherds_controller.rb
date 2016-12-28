class ShepherdsController < ApplicationController
	before_action :logged_in_shepherd, only: [:index, :edit, :update, :destroy]
	before_action :correct_shepherd,   only: [:edit, :update]
	before_action :admin_shepherd,     only: :destroy

	def index
		@shepherds = Shepherd.where(activated: true).paginate(page: params[:page])
	end


	def show
		@shepherd = Shepherd.friendly.find(params[:id])
		redirect_to root_url and return unless @shepherd.activated
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

	private
		def shepherd_params
			params.require(:shepherd).permit(:name, :username, :email, :password, :password_confirmation)
		end


		#Before filters

		#Confirms a logged in shepherd
		def logged_in_shepherd
			unless logged_in?
				store_location
				flash[:danger] = "Please log in."
				redirect_to login_url
			end
		end

		#Confirms the correct shepherd
		def correct_shepherd
			@shepherd = Shepherd.friendly.find(params[:id])
			redirect_to(root_url) unless current_shepherd?(@shepherd)
		end

		def admin_shepherd
			redirect_to(root_url) unless current_shepherd.admin?
		end
end
