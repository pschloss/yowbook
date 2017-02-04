require 'test_helper'

class AddWeightsTest < ActionDispatch::IntegrationTest

	def setup
		@shepherd = shepherds(:michael)
		@animal = @shepherd.animals.first
		@weight = Weight.new(animal_id: @animal.id, weight: 10, weight_type: "birth",
												date: @animal.birth_date)
		@weight.save
	end

	test "weight display" do
		log_in_as(@shepherd)
		get shepherd_animal_path(username: @shepherd.username, eartag: @animal.eartag)
		assert_template 'animals/show'
		assert_select 'table'
		assert_match @weight.date.to_s, response.body
		assert_match @weight.weight.to_s, response.body
		assert_match @weight.weight_type.to_s, response.body
	end

end
