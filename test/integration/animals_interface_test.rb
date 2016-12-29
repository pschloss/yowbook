require 'test_helper'

class AnimalsInterfaceTest < ActionDispatch::IntegrationTest

	def setup
		@shepherd = shepherds(:michael)
	end

	test "animal interface" do
		log_in_as(@shepherd)
		get root_path
		assert_select 'div.pagination'
		assert_select 'input[type=file]'
		#invalid submission
		assert_no_difference 'Animal.count' do
			post animals_path, params: { animal: { eartag: "" } }
		end
		assert_select 'div#error_explanation'

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
		assert_redirected_to root_url
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
		get root_path
		assert_match "#{@shepherd.animals.count} sheep", response.body

		#Shepherd with zero animals
		other_shepherd = shepherds(:malory)
		log_in_as(other_shepherd)
		get root_path
		assert_match "0 sheep", response.body
		other_shepherd.animals.create!(eartag: "12345", birth_date: "2016-04-01")
		get root_path
		assert_match "1 sheep", response.body
	end

end
