require 'test_helper'

class WeightTest < ActiveSupport::TestCase

	def setup
		@shepherd = shepherds(:michael)
		@animal = @shepherd.animals.create(eartag: "12345G", birth_date: Date.civil(2006,4,30))
		@weight = Weight.new(date: Date.civil(2006,4,30), weight: "11.5", weight_type: "birth", animal_id: @animal.id)

	end

	test "should be valid" do
		assert @weight.valid?
	end

	test "animal id should be present" do
		@weight.animal_id = nil
		assert_not @weight.valid?
	end

	test "date should be present" do
		@weight.date = "   "
		assert_not @weight.valid?
	end

	test "weight should be present" do
		@weight.weight = "   "
		assert_not @weight.valid?
	end

	test "weight type should be present" do
		@weight.weight_type = "   "
		assert_not @weight.valid?
	end

	test "weight should be a valid type and date" do

		@weight.weight_type = "birth"
		@weight.date = @animal.birth_date - 1
		assert_not @weight.valid?

		@weight.weight_type = "birth"
		@weight.date = @animal.birth_date + 1
		assert_not @weight.valid?

		@weight.weight_type = "birth"
		@weight.date = @animal.birth_date
		assert @weight.valid?


		@weight.weight_type = "weaning"
		@weight.date = @animal.birth_date
		assert_not @weight.valid?

		@weight.weight_type = "weaning"
		@weight.date = @animal.birth_date + 140
		assert_not @weight.valid?

		@weight.weight_type = "weaning"
		@weight.date = @animal.birth_date + 60
		assert @weight.valid?


		@weight.weight_type = "early_post_weaning"
		@weight.date = @animal.birth_date
		assert_not @weight.valid?

		@weight.weight_type = "early_post_weaning"
		@weight.date = @animal.birth_date + 250
		assert_not @weight.valid?

		@weight.weight_type = "early_post_weaning"
		@weight.date = @animal.birth_date + 160
		assert @weight.valid?


		@weight.weight_type = "post_weaning"
		@weight.date = @animal.birth_date
		assert_not @weight.valid?

		@weight.weight_type = "post_weaning"
		@weight.date = @animal.birth_date + 360
		assert_not @weight.valid?

		@weight.weight_type = "post_weaning"
		@weight.date = @animal.birth_date + 250
		assert @weight.valid?


		@weight.weight_type = "yearling"
		@weight.date = @animal.birth_date
		assert_not @weight.valid?

		@weight.weight_type = "yearling"
		@weight.date = @animal.birth_date + 450
		assert_not @weight.valid?

		@weight.weight_type = "yearling"
		@weight.date = @animal.birth_date + 350
		assert @weight.valid?


		@weight.weight_type = "hogget"
		@weight.date = @animal.birth_date
		assert_not @weight.valid?

		@weight.weight_type = "hogget"
		@weight.date = @animal.birth_date + 600
		assert_not @weight.valid?

		@weight.weight_type = "hogget"
		@weight.date = @animal.birth_date + 450
		assert @weight.valid?


		@weight.weight_type = "adult"
		@weight.date = @animal.birth_date
		assert_not @weight.valid?

		@weight.weight_type = "adult"
		@weight.date = @animal.birth_date + 3000
		assert_not @weight.valid?

		@weight.weight_type = "adult"
		@weight.date = @animal.birth_date + 600
		assert @weight.valid?


		@weight.weight_type = "maintenance"
		@weight.date = @animal.birth_date - 60
		assert_not @weight.valid?

		@weight.weight_type = "maintenance"
		@weight.date = @animal.birth_date + 600
		assert @weight.valid?

		@weight.weight_type = "maintenance"
		@weight.date = @animal.birth_date + 3000
		assert @weight.valid?


		@weight.weight_type = "hanging"
		@weight.date = @animal.birth_date - 60
		assert_not @weight.valid?

		@weight.weight_type = "hanging"
		@weight.date = @animal.birth_date + 300
		assert @weight.valid?

		@weight.weight_type = "hanging"
		@weight.date = @animal.birth_date + 3000
		assert @weight.valid?

	end


	test "date should be properly formatted" do
		@weight.date = "2006-04-30"
		assert @weight.valid?

		@weight.date = "01-21-2017"
		assert_not @weight.valid?

		@weight.date = "2100-01-21"
		assert_not @weight.valid?
	end

end
