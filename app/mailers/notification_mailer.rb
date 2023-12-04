class NotificationMailer < ApplicationMailer
  def new_bid(notification_id)
    @notification = Notification.find_by(id: notification_id)
    return unless @notification

    @bid = @notification.resource
    return unless @bid

    @task = @bid.task
    mail to: @task.user.email, subject: t("mailers.notification_mailer.new_bid.subject", app_name: "Atenas")
  end
end
