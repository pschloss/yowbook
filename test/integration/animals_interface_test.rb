require 'test_helper'

class AnimalsInterfaceTest < ActionDispatch::IntegrationTest

	def setup
		@shepherd = shepherds(:michael)
	end

	test "animal interface" do
		log_in_as(@shepherd)
		follow_redirect!
	  # $stdout.print response.body
		assert_select 'div.pagination'
		assert_select 'input[type=file]'

		#invalid submission
		assert_no_difference 'Animal.count' do
			post animals_path, params: { animal: { eartag: "" } }
		end

		assert_select 'div#error_explanation>ul>li', 2

		#invalid submission
		assert_no_difference 'Animal.count' do
			post animals_path, params: { animal: { eartag: "1402", birth_date: "2090-12-12", dam_eartag: animals(:wether).eartag, sire_eartag: animals(:wether).eartag } }
		end
		assert_select 'div#error_explanation>ul>li', 5

		#invalid submission
		assert_no_difference 'Animal.count' do
			post animals_path, params: { animal: { eartag: "1400", birth_date: "12/12/2015", dam_eartag: "1400", sire_eartag: "1400" } }
		end
		assert_select 'div#error_explanation>ul>li', 4

		#invalid submission
		assert_no_difference 'Animal.count' do
			post animals_path, params: { animal: { eartag: "1400", birth_date: "2015/12/12", dam_eartag: "1400", sire_eartag: "1400" } }
		end
		assert_select 'div#error_explanation>ul>li', 4


		#valid submission
		eartag = "123ABC"
		birth_date = "2016-04-20"
		picture = fixture_file_upload('images/rails.png', 'image/png')
		assert_difference 'Animal.count', 1 do
			post animals_path, params: { animal: {  eartag: eartag,
																							birth_date: birth_date,
 																							picture: picture } }
		end
		assert_redirected_to shepherd_path(@shepherd)
		follow_redirect!

		#valid submission 2
		eartag = "123ABD"
		birth_date = "2016-04-20"
		picture = fixture_file_upload('images/rails.png', 'image/png')
		assert_difference 'Animal.count', 1 do
			post animals_path, params: { animal: {  eartag: eartag,
																							birth_date: birth_date,
 																							picture: picture,
																							dam_eartag: animals(:dam).eartag,
																							sire_eartag: animals(:sire).eartag,
																							sex: "ewe"} }
		end
		assert_redirected_to shepherd_path(@shepherd)
		follow_redirect!

		#valid submission 3
		eartag = "123ABDE"
		birth_date = "2016-04-20"
		picture = fixture_file_upload('images/rails.png', 'image/png')
		assert_difference 'Animal.count', 1 do
			post animals_path, params: { animal: {  eartag: eartag,
																							birth_date: birth_date,
 																							picture: picture,
																							sire_eartag: animals(:sire).eartag,
																							sex: "ewe"} }
		end
		assert_redirected_to shepherd_path(@shepherd)
		follow_redirect!

		#delete animal
		first_animal = @shepherd.animals.paginate(page: 1).first
		get shepherd_animal_path(username: @shepherd.username, eartag: first_animal.eartag)
		assert_select 'div#weights', count: 1
		assert_select 'div#edit', count: 1
		assert_select 'a', text: 'Delete animal', count: 1

		assert_difference 'Animal.count', -1 do
			delete animal_path(first_animal)
		end
		assert_redirected_to shepherd_path(@shepherd)

	end

	test "animal sidebar count" do
		log_in_as(@shepherd)
		follow_redirect!
		assert_match "#{@shepherd.animals.count} sheep", response.body

		#Shepherd with zero animals
		other_shepherd = shepherds(:malory)
		log_in_as(other_shepherd)
		follow_redirect!
		assert_match "0 sheep", response.body
		other_shepherd.animals.create!(eartag: "12345", birth_date: "2016-04-01")
		get shepherd_path(other_shepherd)
		assert_match "1 sheep", response.body
	end


	test "animal links" do
		log_in_as(@shepherd)
		follow_redirect!

		first_animal = @shepherd.animals.first
		get shepherd_animal_path(username: @shepherd.username, eartag: first_animal.eartag)
		assert_template 'animals/show'
		assert_select 'div#edit', count: 1
		assert_select 'a', text: 'Delete animal', count: 1

		@other_shepherd = shepherds(:archer)
		get shepherd_path(@other_shepherd)
		other_animal = @other_shepherd.animals.first
		get shepherd_animal_path(username: @other_shepherd.username, eartag: other_animal.eartag)
		assert_template 'animals/show'
		assert_select 'div#edit', count: 0
		assert_select 'a', text: 'Delete animal', count: 0
	end
end
