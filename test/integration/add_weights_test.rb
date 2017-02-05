require 'test_helper'

class AddWeightsTest < ActionDispatch::IntegrationTest

	def setup
		@shepherd = shepherds(:michael)
		@animal = @shepherd.animals.first
		@weight = Weight.new(animal_id: @animal.id, weight: 10, weight_type: "birth",
												date: @animal.birth_date)
		@weight.save

		@other_shepherd = shepherds(:archer)
		@other_animal = @other_shepherd.animals.first
		@other_weight = Weight.new(animal_id: @other_animal.id, weight: 10, weight_type: "birth",
												date: @other_animal.birth_date)
		@other_weight.save

	end

	test "weight display" do
		log_in_as(@shepherd)
		get shepherd_animal_path(username: @shepherd.username, eartag: @animal.eartag)
		assert_template 'animals/show'
		assert_select 'table'
		assert_match @weight.date.to_s, response.body
		assert_match @weight.weight.to_s, response.body
		assert_match @weight.weight_type.to_s, response.body
		assert_equal @animal.last_weight, 10
		assert_match @animal.last_weight.to_s, response.body
	end


	test "add a weight" do
		log_in_as(@shepherd)
		get shepherd_animal_path(username: @shepherd.username, eartag: @animal.eartag)

		#should be able to add a weight to my animals
		post animal_weights_path(@animal.id), params: { weight: { date: "2017-01-01", weight_type: "maintenance", weight: 200 } }
		follow_redirect!
		assert_template 'animals/show'
		assert_template 'weights/_weight'
		assert_template 'shared/_weight_form', 1
		assert_match "2017-01-01", response.body

		#when i add a weight that is more recent, it should update teh last weight field
		assert_match "200.0", response.body, 2

		#my weights should be hyperlinked
		assert_match 'data-link', response.body, 2



		#update an existing weight
		get edit_weight_path(@animal.weights.last)
		assert_template 'animals/show'
		assert_template 'weights/_weight'
		assert_template 'shared/_weight_form', 1
		assert_match 'Update', response.body, 1
		assert_match 'Cancel', response.body, 1
		assert_match 'Delete', response.body, 1

		assert_no_difference 'Weight.count' do
			patch weight_path(@animal.weights.last), params: { weight: { date: "2017-01-01", weight_type: "maintenance", weight: 190 } }
		end
		follow_redirect!
		assert_template 'animals/show'
		assert_template 'weights/_weight'
		assert_template 'shared/_weight_form', 1
		assert_match "2017-01-01", response.body
		assert_no_match "200.0", response.body
		assert_match "190.0", response.body, 2

		#delete an existing weight
		recent_animal = @animal.weights.last
		get edit_weight_path(recent_animal)
		assert_match 'Delete', response.body, 1

		assert_difference 'Weight.count', -1 do
			delete weight_path(recent_animal)
		end
		assert_redirected_to shepherd_animal_path(username: @shepherd.username, eartag: @animal.eartag)
		follow_redirect!
		assert_no_match "190.0", response.body
		assert_match "10.0", response.body, 2


		#shouldn't be able to see the weight creation form for another user
		get shepherd_animal_path(username: @other_shepherd.username, eartag: @other_animal.eartag)
		assert_template 'animals/show'
		assert_template 'weights/_weight'
		assert_template partial: 'shared/_weight_form', count: 0

		#another user's weights should not be hyperlinked
		assert_no_match 'data-link', response.body
	end




end
