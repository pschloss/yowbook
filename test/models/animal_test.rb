require 'test_helper'

class AnimalTest < ActiveSupport::TestCase

	def setup
		date = Date.civil(2015,4,30)
		@shepherd = shepherds(:michael)
		@animal = @shepherd.animals.build(eartag: "12345G", birth_date: date)
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

	test "duplicate eartags should be flagged" do
		@animal.eartag = "1601"
		assert_not @animal.valid?
	end

	test "unique eartag should be validated" do
		@animal.eartag = "2001"
		assert @animal.valid?
	end


	test "eartag should be at most 20 characters" do
		@animal.eartag = "a" * 21
		assert_not @animal.valid?
	end

	test "dam should be at most 20 characters" do
		@animal.dam = "a" * 21
		assert_not @animal.valid?
	end

	test "sire should be at most 20 characters" do
		@animal.sire = "a" * 21
		assert_not @animal.valid?
	end

	test "dam eartag should be different from lamb's eartag" do
		@animal.dam = "12345G"
		assert_not @animal.valid?
	end

	test "sire eartag should be different from lamb's eartag" do
		@animal.sire = "12345G"
		assert_not @animal.valid?
	end

	test "dam and sire should have different eartags" do
		@animal.dam = "12345G"
		@animal.sire = "12345G"
		assert_not @animal.valid?
	end

	test "should complain about an incorrect sex" do
		@animal.sex = "dog"
		assert_not @animal.valid?
	end

	test "should accept a correct sex" do
		@animal.sex = "wether"
		assert @animal.valid?
	end

	test "should accept a valid status" do
		@animal.status = 'culled'
		@animal.status_date = @animal.birth_date + 6.months
	end

	test "order should be most recent birth date first" do
		@animal = @shepherd.animals.build(eartag: "12346", birth_date: Date.current)
		@animal.save
		assert_equal @animal, Animal.first
	end

	test "next eartag should be one more than previous eartag" do

		@animal = @shepherd.animals.create(eartag: "12345", birth_date: Date.current)
		@animal.save
		assert_equal "12346", @shepherd.animals.build.eartag

		@animal = @shepherd.animals.build(eartag: "12344", birth_date: Date.current)
		@animal.save
		assert_equal "12346", @shepherd.animals.build.eartag

		@other_shepherd = shepherds(:archer)
		@animal = @other_shepherd.animals.create(eartag: "12346", birth_date: Date.current)
		@animal.save

		assert_equal "12346", @shepherd.animals.build.eartag


#need to see what happens if archer adds an animal.

	end
end
