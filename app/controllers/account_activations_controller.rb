class AccountActivationsController < ApplicationController

	def edit
		shepherd = Shepherd.find_by(email: params[:email])
		if shepherd && !shepherd.activated? && shepherd.authenticated?(:activation, params[:id])
			shepherd.activate
			log_in shepherd
			flash[:success] = "Account activated"
			redirect_to shepherd_path(shepherd)
		else
			flash[:danger] = "Invalid activation link"
			redirect_to root_url
		end
	end

end
