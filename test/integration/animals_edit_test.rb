require 'test_helper'

class AnimalsEditTest < ActionDispatch::IntegrationTest

	def setup
		@shepherd = shepherds(:michael)
		@animal = @shepherd.animals.first
	end


	test "unsuccessful edit" do
		log_in_as(@shepherd)
		get shepherd_animal_path(@shepherd.username, @animal.eartag)
		assert_template partial: 'animals/_edit_data'
		assert_template 'animals/show'

		patch animal_path(@animal), params: { animal: { eartag: "",
																										dam_eartag: "1",
																										sire_eartag: "1",
																										sex: "unknown",
																										status: "stillborn"
 																										} }

		assert_template partial: 'animals/_edit_data'
		assert_select 'div#error_explanation li', count: 4
	end

	test "successful edit with friendly forwarding" do
		log_in_as(@shepherd)
		get shepherd_animal_path(@shepherd.username, @animal.eartag)
		assert_template partial: 'animals/_edit_data'
		assert_template 'animals/show'

		patch animal_path(@animal), params: { animal: { status: "died",
																										status_date: Date.today
 																										}
																				}
		assert_not flash.empty?
		@animal.reload
		assert_redirected_to shepherd_animal_path(@shepherd.username, @animal.eartag)
	end


end
