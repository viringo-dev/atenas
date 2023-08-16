class UserMailer < ApplicationMailer
  default from: User::MAILER_FROM_EMAIL

  def confirmation(user, confirmation_token)
    @user = user
    @confirmation_token = confirmation_token

    mail to: @user.email, subject: t("mailers.user_mailer.confirmation.subject", app_name: "Atenas")
  end

  def password_reset(user, password_reset_token)
    @user = user
    @password_reset_token = password_reset_token

    mail to: @user.email, subject: t("mailers.user_mailer.password_reset.subject", app_name: "Atenas")
  end
end
