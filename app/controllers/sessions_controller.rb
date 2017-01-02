class SessionsController < ApplicationController
	attr_accessor :login
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	VALID_USERNAME_REGEX = /\A[\S]*\z/i


	def new
  end

	def create

		login = params[:session][:login]

		if !!(login =~ VALID_EMAIL_REGEX)
			shepherd = Shepherd.find_by(email: params[:session][:login].downcase)
		elsif !!(login =~ VALID_USERNAME_REGEX)
		 	shepherd = Shepherd.find_by(username: params[:session][:login].downcase)
		end

		if shepherd && shepherd.authenticate(params[:session][:password])
			if shepherd.activated?
				log_in shepherd
				params[:session][:remember_me] == '1' ? remember(shepherd) : forget(shepherd)
				flash[:success] = "Welcome back to Yowbook!"
				redirect_back_or shepherd_path(shepherd)
			else
				message = "Account not activated. "
				message += "Check your email for the activation link"
				flash[:warning] = message
				redirect_to root_url
			end
		else
			flash.now[:danger] = "Invalid login combination"
			render 'new'
		end
	end

	def destroy
		log_out if logged_in?
		redirect_to root_url
	end
end
