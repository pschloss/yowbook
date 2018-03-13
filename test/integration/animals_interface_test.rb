require 'test_helper'

class AnimalsInterfaceTest < ActionDispatch::IntegrationTest

	def setup
		@shepherd = shepherds(:michael)
	end

	test "animal interface" do
		log_in_as(@shepherd)
		follow_redirect!
	  # $stdout.print response.body
		assert_select 'nav.pagination'
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
																							dam_eartag: animals(:dam).eartag,
																							sire_eartag: animals(:sire).eartag,
 																							picture: picture } }
		end
		assert_redirected_to shepherd_path(@shepherd)
		follow_redirect!

		#valid submission 2
		eartag = "123ABD"
		birth_date = "2016-04-20"
		picture = fixture_file_upload('images/rails.png', 'image/png')
		sex = "ewe"
		assert_difference 'Animal.count', 1 do
			post animals_path, params: { animal: {  eartag: eartag,
																							birth_date: birth_date,
 																							picture: picture,
																							dam_eartag: animals(:dam).eartag,
																							sire_eartag: animals(:sire).eartag,
																							sex: sex} }
		end
		assert_redirected_to shepherd_path(@shepherd)
		follow_redirect!

		get shepherd_animal_path(username: @shepherd.username, eartag: eartag)
		assert_template 'animals/show'


		#test pedigree display
		assert_match "<td rowspan=8><p class='current'>#{eartag} (E)</p>", response.body
		assert_match "<td rowspan=4><a class=\"\" href=\"/shepherds/#{@shepherd.username}/#{animals(:sire).eartag}\">#{animals(:sire).eartag} (R)</a></td>", response.body
		assert_match "<td rowspan=4><a class=\"\" href=\"/shepherds/#{@shepherd.username}/#{animals(:dam).eartag}\">#{animals(:dam).eartag} (E)</a></td>", response.body


		#test edit display
		assert_match "value=\"#{eartag}\"", response.body
		assert_match "value=\"#{birth_date}\"", response.body
		assert_match "selected=\"selected\" value=\"#{sex}\"", response.body
		assert_match "value=\"#{animals(:dam).eartag}\"", response.body
		assert_match "value=\"#{animals(:sire).eartag}\"", response.body
		# assert_match /active.*Raised/, response.body
		assert_match /selected.*Active/, response.body


		get shepherd_animal_path(username: @shepherd.username, eartag: animals(:dam).eartag)

	  # $stdout.print response.body

		#valid submission 3
		eartag = "123ABDE"
		birth_date = "2017-04-20"
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

		get shepherd_animal_path(username: @shepherd.username, eartag: animals(:dam).eartag)

		#test progeny count
		assert_match(/3 \/ 3 \/ 2/, response.body)

		# make a lamb an orphan
		@animal = @shepherd.animals.find_by(eartag: "123ABD")
		get shepherd_animal_path(@shepherd.username, @animal.eartag)

		patch animal_path(@animal), params: { animal: { orphan: "true",
																										status_date: Date.today
 																										}
																				}
		follow_redirect!
		assert_match(/Raised as.*Orphan/, response.body)

		get shepherd_animal_path(username: @shepherd.username, eartag: animals(:dam).eartag)
		assert_match(/3 \/ 2 \/ 2/, response.body)

		# kill that lamb
		@animal = @shepherd.animals.find_by(eartag: "123ABD")
		get shepherd_animal_path(@shepherd.username, @animal.eartag)

		patch animal_path(@animal), params: { animal: { status: "stillborn",
																										status_date: Date.today
 																										}
																				}
		assert_match(/Raised as.*Stillborn/, response.body)

		get shepherd_animal_path(username: @shepherd.username, eartag: animals(:dam).eartag)
		assert_match(/3 \/ 2 \/ 2/, response.body)

#		$stdout.print response.body

		# bring lamb back to life
		@animal = @shepherd.animals.find_by(eartag: "123ABD")
		get shepherd_animal_path(@shepherd.username, @animal.eartag)

		patch animal_path(@animal), params: { animal: { status: "active",
																										orphan: false,
																										status_date: Date.today
 																										}
																				}
		follow_redirect!
		assert_match(/Raised as.*Twin/, response.body)

		get shepherd_animal_path(username: @shepherd.username, eartag: animals(:dam).eartag)
		assert_match(/3 \/ 3 \/ 2/, response.body)


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
