require 'test_helper'

class AnimalTest < ActiveSupport::TestCase

	def setup
		@shepherd = shepherds(:michael)
		@animal = @shepherd.animals.build(eartag: "12345G", birth_date: Date.civil(2015,4,30))
	end

	test "should be valid" do
		assert @animal.valid?
	end

	test "shepherd id should be present" do
		@animal.shepherd_id = nil
		assert_not @animal.valid?
	end

	test "eartag should be present" do
		@animal.eartag = "   "
		assert_not @animal.valid?
	end

	test "content should be at most 20 characters" do
		@animal.eartag = "a" * 21
		assert_not @animal.valid?
	end

	test "order should be most recent birth date first" do
		assert_equal animals(:fourth), Animal.first
	end

end