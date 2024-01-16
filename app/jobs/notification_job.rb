class NotificationJob < ApplicationJob
  include Rails.application.routes.url_helpers

  def perform(resource_id, notification_type)
    return unless resource_id
    return unless notification_type
    
    case notification_type
    when Notification.notification_types[:new_bid]
      bid = Bid.find_by(id: resource_id)
      if bid
        notification = Notification.new(resource: bid, user: bid.task.user, notification_type: notification_type, path: task_path(bid.task_id))
        if notification.save
          NotificationMailer.new_bid(notification.id).deliver_later
        end
      end
    when Notification.notification_types[:accepted_bid]
      bid = Bid.find_by(id: resource_id)
      if bid
        channel = bid.task.channel
        notification_for_bidder = Notification.new(resource: bid, user: bid.user, notification_type: notification_type, path: messages_path(uuid: channel.uuid))
        if notification_for_bidder.save
          NotificationMailer.accepted_bid(notification_for_bidder.id).deliver_later
        end

        notification_for_task_owner = Notification.new(resource: bid.task, user: bid.task.user, notification_type: Notification.notification_types[:payment_validated], path: messages_path(uuid: channel.uuid))
        if notification_for_task_owner.save
          NotificationMailer.payment_validated(notification_for_task_owner.id).deliver_later
        end
      end
    else
    end
  end
end
