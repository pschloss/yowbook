require 'test_helper'

class ShepherdTest < ActiveSupport::TestCase

	def setup
		@shepherd = Shepherd.new(	name: "Example Shepherd",
															username: "ExampleShepherd",
															email: "shepherd@example.com",
															password: "foobar",
															password_confirmation: "foobar")
	end



	test "should be valid" do
		assert @shepherd.valid?
	end

	test "name should not be valid" do
		@shepherd.name = "        "
		assert_not @shepherd.valid?
	end

	test "name should not be too long" do
		@shepherd.name = "a" * 51
		assert_not @shepherd.valid?
	end



	test "email should not be valid" do
		@shepherd.email = "        "
		assert_not @shepherd.valid?
	end

	test "email should not be too long" do
		@shepherd.email = "a" * 244 + "@example.com"
		assert_not @shepherd.valid?
	end

  test "email validation should accept valid addresses" do
    valid_addresses = %w[shepherd@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @shepherd.email = valid_address
      assert @shepherd.valid?, "#{valid_address.inspect} should be valid"
		end
	end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[shepherd@example,com shepherd_at_foo.org shepherd.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @shepherd.email = invalid_address
      assert_not @shepherd.valid?, "#{invalid_address.inspect} should be invalid"
		end
	end

  test "email addresses should be unique" do
    duplicate_shepherd = @shepherd.dup
    duplicate_shepherd.email = @shepherd.email.upcase
    @shepherd.save
    assert_not duplicate_shepherd.valid?
	end

	test "email addresses should be saved as lowercase" do
		mixed_case_email = "Foo@ExAmPlE.cOm"
		@shepherd.email = mixed_case_email
		@shepherd.save
		assert_equal mixed_case_email.downcase, @shepherd.reload.email
	end



	test "username should not be valid" do
		@shepherd.username = "        "
		assert_not @shepherd.valid?
	end

	test "username should not be too long" do
		@shepherd.username = "a" * 51
		assert_not @shepherd.valid?
	end

	test "username should not contain spaces" do
		@shepherd.username = "foo bar"
		assert_not @shepherd.valid?
	end

	test "username should be saved as lowercase" do
		mixed_case_username = "FoObAr"
		@shepherd.username = mixed_case_username
		@shepherd.save
		assert_equal mixed_case_username.downcase, @shepherd.reload.username
	end

  test "username validation should accept valid usernames" do
    valid_usernames = %w[foobar foo_bar foo.bar foo-bar foo1bar foo!bar]
    valid_usernames.each do |valid_username|
      @shepherd.username = valid_username
      assert @shepherd.valid?, "#{@shepherd.username} #{valid_username.inspect} should be valid"
		end
	end



	test "password should be present" do
		@shepherd.password = @shepherd.password_confirmation = " " * 6
		assert_not @shepherd.valid?
	end

	test "password should have a minimum length" do
		@shepherd.password = @shepherd.password_confirmation = "a" * 5
		assert_not @shepherd.valid?
	end



	test "authenticated? should return false for a shepherd with nil digest" do
		assert_not @shepherd.authenticated?(:remember, '')
	end



	test "associated microposts should be destroyed" do
		@shepherd.save
		@shepherd.animals.create!(eartag: "12345G", birth_date: Date.civil(2015,4,30) )
		assert_difference 'Animal.count', -1 do
			@shepherd.destroy
		end
	end

end
