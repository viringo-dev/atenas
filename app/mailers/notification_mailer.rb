class NotificationMailer < ApplicationMailer
  def new_bid(notification_id)
    @notification = Notification.find_by(id: notification_id)
    return unless @notification

    @bid = @notification.resource
    return unless @bid

    @task = @bid.task
    mail to: @task.user.email, subject: t("mailers.notification_mailer.new_bid.subject", app_name: "Atenas")
  end

  def accepted_bid(notification_id)
    @notification = Notification.find_by(id: notification_id)
    return unless @notification

    @bid = @notification.resource
    return unless @bid

    @task = @bid.task
    mail to: @bid.user.email, subject: t("mailers.notification_mailer.accepted_bid.subject", app_name: "Atenas")
  end

  def payment_validated(notification_id)
    @notification = Notification.find_by(id: notification_id)
    return unless @notification

    @task = @notification.resource
    return unless @task

    mail to: @task.user.email, subject: t("mailers.notification_mailer.payment_validated.subject", app_name: "Atenas")
  end

  def cashout_validated(notification_id)
    @notification = Notification.find_by(id: notification_id)
    return unless @notification

    @bid = @notification.resource
    return unless @bid

    @task = @bid.task
    mail to: @bid.user.email, subject: t("mailers.notification_mailer.cashout_validated.subject")
  end
end
