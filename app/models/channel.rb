class Channel < ApplicationRecord
  ## ASSOCIATIONS ##
  belongs_to :task
  has_many :messages, dependent: :destroy
  has_many :channel_users, dependent: :destroy

  ## VALIDATIONS ##
  validates :task, presence: { allow_blank: false }

  ## SCOPES ##
  scope :with_unread_messages_count_by, ->(user) { select("channels.*, (SELECT COUNT(*)
                                                                        FROM messages
                                                                        WHERE messages.channel_id = channels.id
                                                                        AND messages.created_at > channel_users.last_read_at) AS unread_messages_count")
                                                   .joins(:channel_users)
                                                   .where(channel_users: { user: user })
                                                   .order(created_at: :desc) }
end
