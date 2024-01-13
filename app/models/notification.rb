class Notification < ApplicationRecord
  ## ASSOCIATIONS ##
  belongs_to :resource, polymorphic: true
  belongs_to :user

  ## VALIDATIONS ##
  validates :user, presence: { allow_blank: false }
  validates :resource, presence: { allow_blank: false }

  ## CALLBACKS ##
  after_create_commit -> { broadcast_update_later_to self.user, partial: "notifications/new_notification", target: "new-notification", locals: { notification: self } }
  after_create_commit -> { broadcast_prepend_later_to self.user, partial: "notifications/notification", target: "notifications" }

  ## ENUMS ##
  enum notification_type: { new_bid: 0,
                            accepted_bid: 1
                          }

  ## SCOPES ##
  scope :ordered, -> { order(created_at: :desc) }
  scope :unread, -> { where(readed: false) }
end
