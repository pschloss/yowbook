module SessionsHelper

	# Logs in the given shepherd.
	def log_in(shepherd)
		session[:shepherd_id] = shepherd.id
	end

	# Remembers a shepherd in a persistent session
	def remember(shepherd)
		shepherd.remember
		cookies.permanent.signed[:shepherd_id] = shepherd.id
		cookies.permanent[:remember_token] = shepherd.remember_token
	end

	def current_shepherd?(shepherd)
		shepherd == current_shepherd
	end

	# Returns the current logged-in shepherd (if any).
	def current_shepherd
		if(shepherd_id = session[:shepherd_id])
			@current_shepherd ||= Shepherd.find_by(id: shepherd_id)
		elsif(shepherd_id = cookies.signed[:shepherd_id])
			shepherd = Shepherd.find_by(id: shepherd_id)
			if shepherd && shepherd.authenticated?(:remember, cookies[:remember_token])
				log_in shepherd
				@current_shepherd = shepherd
			end
		end
	end

	# Returns true if the shepherd is logged in, false otherwise.
	def logged_in?
		!current_shepherd.nil?
	end

	def forget(shepherd)
		shepherd.forget
		cookies.delete(:shepherd_id)
		cookies.delete(:remember_token)
	end

	def log_out
		forget(current_shepherd)
		session.delete(:shepherd_id)
		@current_shepherd = nil
	end

	def redirect_back_or(default)
		redirect_to(session[:forwarding_url] || default)
		session.delete(:forwarding_url)
	end

	def store_location
		session[:forwarding_url] = request.original_url if request.get?
	end

end
