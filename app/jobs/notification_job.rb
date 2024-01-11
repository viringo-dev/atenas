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
    else
    end
  end
end
