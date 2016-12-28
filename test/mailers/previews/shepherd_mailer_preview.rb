# Preview all emails at http://localhost:3000/rails/mailers/shepherd_mailer
class ShepherdMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/shepherd_mailer/account_activation
  def account_activation
		shepherd = Shepherd.first
		shepherd.activation_token = Shepherd.new_token
    ShepherdMailer.account_activation(shepherd)
  end

  # Preview this email at http://localhost:3000/rails/mailers/shepherd_mailer/password_reset
  def password_reset
		shepherd = Shepherd.first
		shepherd.reset_token = Shepherd.new_token
    ShepherdMailer.password_reset(shepherd)
  end

end
