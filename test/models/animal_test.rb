require 'test_helper'

class AnimalTest < ActiveSupport::TestCase

	def setup
		date = Date.civil(2015,4,30)
		@shepherd = shepherds(:michael)
		@animal = @shepherd.animals.build(eartag: "12345G", birth_date: date)
		@dam = animals(:dam)
		@sire = animals(:sire)

		@wether = animals(:wether)
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

	test "dam eartag should be different from lamb's eartag" do
		@animal.dam_eartag = "12345G"
		assert_not @animal.valid?
	end

	test "sire eartag should be different from lamb's eartag" do
		@animal.sire_eartag = "12345G"
		assert_not @animal.valid?
	end

	test "dam and sire should have different eartags" do
		@animal.dam_eartag = "12345G"
		@animal.sire_eartag = "12345G"
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

	test "dam and ram should exist" do
		@animal.sire_eartag = "ABCD"
		assert_not @animal.valid?

		@animal.dam_eartag = "ABCD"
		assert_not @animal.valid?
	end

	test "dam should be a ewe" do
		@animal.update(dam: @dam)
		assert @animal.valid?
		@animal.update(dam: @sire)
		assert_not @animal.valid?
		@animal.update(dam: @wether)
		assert_not @animal.valid?
	end

	test "sire should be a ram" do
		@animal.update(sire: @sire)
		assert @animal.valid?
		@animal.update(sire: @dam)
		assert_not @animal.valid?
		@animal.update(sire: @wether)
		assert_not @animal.valid?
	end

	test "rams should not have children_as_dam" do
		@animal.update(sire: animals(:sire), dam: animals(:dam))
		assert @sire.children.size == 1
		assert @sire.children_as_dam.size == 0
	end

	test "ewes should not have children_as_sire" do
		@animal.update(sire: animals(:sire), dam: animals(:dam))
		assert @dam.children.size == 1
		assert @dam.children_as_sire.size == 0
	end

	test "wethers should not have children_as_ram or children_as_dam" do
		@animal.update(sire: @wether)
		assert_not @animal.valid?
		assert @wether.children_as_sire.size == 0
		assert @wether.children_as_dam.size == 0
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
		assert_equal "12347", @shepherd.animals.build.eartag

	end
end
