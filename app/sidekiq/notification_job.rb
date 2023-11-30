class NotificationJob
  include Sidekiq::Job
  include Rails.application.routes.url_helpers

  def perform(resource_id, notification_type)
    return unless resource_id
    return unless notification_type
    
    case notification_type
    when Notification.notification_types[:new_bid]
      bid = Bid.find_by(id: resource_id)
      Notification.create(resource: bid, user: bid.task.user, notification_type: notification_type, path: task_path(bid.task_id)) if bid
    else
    end
  end
end
