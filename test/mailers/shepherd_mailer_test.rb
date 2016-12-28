require 'test_helper'

class ShepherdMailerTest < ActionMailer::TestCase
  test "account_activation" do
		shepherd = shepherds(:michael)
		shepherd.activation_token = Shepherd.new_token
    mail = ShepherdMailer.account_activation(shepherd)
    assert_equal "Account activation", mail.subject
    assert_equal [shepherd.email], mail.to
    assert_equal ["noreply@example.com"], mail.from
    assert_match shepherd.name, mail.body.encoded
    assert_match shepherd.activation_token, mail.body.encoded
    assert_match CGI.escape(shepherd.email), mail.body.encoded
  end

  test "password_reset" do
		shepherd = shepherds(:michael)
		shepherd.reset_token = Shepherd.new_token
    mail = ShepherdMailer.password_reset(shepherd)

    assert_equal "Password reset", mail.subject
		assert_equal [shepherd.email], mail.to
    assert_match shepherd.reset_token, mail.body.encoded
    assert_match CGI.escape(shepherd.email), mail.body.encoded
  end

end
