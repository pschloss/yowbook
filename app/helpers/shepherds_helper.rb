module ShepherdsHelper

	# Returns the Gravatar for the given shepherd.
	def gravatar_for(shepherd, size: 80 )
		gravatar_id = Digest::MD5::hexdigest(shepherd.email.downcase)
		gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
		image_tag(gravatar_url, alt: shepherd.name, class: "gravatar")
	end

end
