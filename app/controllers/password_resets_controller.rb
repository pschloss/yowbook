class PasswordResetsController < ApplicationController
	before_action :get_shepherd,         only: [:edit, :update]
	before_action :valid_shepherd,       only: [:edit, :update]
	before_action :check_expiration, only: [:edit, :update]

  def new
  end

	def create
		@shepherd = Shepherd.find_by(email: params[:password_reset][:email].downcase)
		if @shepherd
			@shepherd.create_reset_digest
			@shepherd.send_password_reset_email
			flash[:info] = "Email sent with password reset instructions"
			redirect_to root_url
		else
			flash.now[:danger] = "Email address not found"
			render 'new'
		end
	end

  def edit
  end

	def update
		if params[:shepherd][:password].empty?
			@shepherd.errors.add(:password, "can't be empty")
			render 'edit'
		elsif @shepherd.update_attributes(shepherd_params)
			log_in @shepherd
			@shepherd.update_attribute(:reset_digest, nil)
			flash[:success] = "Password has been reset."
			redirect_to @shepherd
		else
			render 'edit'
		end
	end



	private
		def shepherd_params
			params.require(:shepherd).permit(:password, :password_confirmation)
		end


		def get_shepherd
			@shepherd = Shepherd.find_by(email: params[:email])
		end

		def valid_shepherd
			unless(@shepherd && @shepherd.activated? && @shepherd.authenticated?(:reset, params[:id]))
				redirect_to root_url
			end
		end

		def check_expiration
			if @shepherd.password_reset_expired?
				flash[:danger] = "Password reset has expired."
				redirect_to new_password_reset_url
			end
		end
end
