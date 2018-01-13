module AnimalsHelper

def pedigree_link(eartag, sex, cl="")

	if cl == "current"

		"<p class='current'>#{eartag} (#{sex})</p>".html_safe

	elsif eartag != "Unknown"
		link_to(shepherd_animal_path(username: @shepherd, eartag: eartag), class: cl) do
			"#{eartag} (#{sex})".html_safe
		end
	else
		"<p>#{eartag} (#{sex})</p>".html_safe
	end

end

end
