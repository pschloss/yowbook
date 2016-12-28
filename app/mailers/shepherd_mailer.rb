class ShepherdMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.shepherd_mailer.account_activation.subject
  #
  def account_activation(shepherd)
		@shepherd = shepherd
		mail to: shepherd.email, subject: "Account activation"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.shepherd_mailer.password_reset.subject
  #
  def password_reset(shepherd)
		@shepherd = shepherd
		mail to: shepherd.email, subject: "Password reset"
  end
end
