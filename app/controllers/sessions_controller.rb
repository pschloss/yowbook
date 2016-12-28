class SessionsController < ApplicationController
  def new
  end

	def create
		shepherd = Shepherd.find_by(email: params[:session][:email].downcase)

		if shepherd && shepherd.authenticate(params[:session][:password])
			if shepherd.activated?
				log_in shepherd
				params[:session][:remember_me] == '1' ? remember(shepherd) : forget(shepherd)
				flash[:success] = "Welcome back to Yowbook!"
				redirect_back_or shepherd
			else
				message = "Account not activated. "
				message += "Check your email for the activation link"
				flash[:warning] = message
				redirect_to root_url
			end
		else
			flash.now[:danger] = "Invalid email/password combination"
			render 'new'
		end
	end

	def destroy
		log_out if logged_in?
		redirect_to root_url
	end
end
