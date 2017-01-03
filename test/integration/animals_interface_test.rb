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
			post animals_path, params: { animal: { eartag: "1234", birth_date: "2090-12-12", dam: "1234", sire: "1234" } }
		end
		assert_select 'div#error_explanation>ul>li', 4

		#invalid submission
		assert_no_difference 'Animal.count' do
			post animals_path, params: { animal: { eartag: "1234", birth_date: "12/12/2015", dam: "1234", sire: "1234" } }
		end
		assert_select 'div#error_explanation>ul>li', 4

		#invalid submission
		assert_no_difference 'Animal.count' do
			post animals_path, params: { animal: { eartag: "1234", birth_date: "2015/12/12", dam: "1234", sire: "1234" } }
		end
		assert_select 'div#error_explanation>ul>li', 4


		#valid submission
		eartag = "123ABC"
		birth_date = "2016-04-20"
		picture = fixture_file_upload('images/rails.png', 'image/png')
		assert_difference 'Animal.count', 1 do
			post animals_path, params: { animal: {  eartag: eartag,
																							birth_date: birth_date,
 																							picture: picture} }
		end
		assert assigns(:animal).picture?
		assert_redirected_to shepherd_path(@shepherd)
		follow_redirect!

		#valid submission 2
		eartag = "123ABD"
		birth_date = "2016-04-20"
		dam = "1"
		sire = "2"
		picture = fixture_file_upload('images/rails.png', 'image/png')
		assert_difference 'Animal.count', 1 do
			post animals_path, params: { animal: {  eartag: eartag,
																							birth_date: birth_date,
 																							picture: picture,
																							dam: dam,
																							sire: sire,
																							sex: "ewe"} }
		end
		assert assigns(:animal).picture?
		assert_redirected_to shepherd_path(@shepherd)
		follow_redirect!



		#delete post
		assert_select 'a', text: 'Delete'
		first_animal = @shepherd.animals.paginate(page: 1).first
		assert_difference 'Animal.count', -1 do
			delete animal_path(first_animal)
		end

		#visit different user
		get shepherd_path(shepherds(:archer))
		assert_select 'a', text: 'delete', count: 0
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

end
