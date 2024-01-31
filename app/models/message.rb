class Message < ApplicationRecord
  ## ASSOCIATIONS ##
  belongs_to :channel
  belongs_to :user
  has_many_attached :attachments, dependent: :destroy

  ## VALIDATIONS ##
  validates :content, presence: { allow_blank: false, message: :blank }, if: -> { attachments.empty? }

  ## CALLBACKS ##
  after_create_commit :broadcast_message
  after_create_commit :notify_message

  ## SCOPES ##
  scope :ordered, ->(order = :asc) { order(created_at: order) }
  scope :paginated, ->(params={}) { page(params[:page]).per(params[:per_page]) }

  private

  def broadcast_message
    self.channel.channel_users.includes(:user).each do |channel_user|
      broadcast_prepend_later_to channel_user.user, partial: "messages/message", target: "#{channel.uuid}-messages"
    end
  end

  def notify_message
    self.channel.channel_users.includes(:user).each do |channel_user|
      if channel_user.user == self.user
        channel_user.touch(:last_read_at)
        next
      end
      broadcast_update_later_to channel_user.user, partial: "messages/message_notification", target: "message-notification", locals: { channel: channel }
      broadcast_update_later_to channel_user.user, partial: "messages/channel_notification", target: channel.uuid, locals: { channel: channel }
    end
  end
end
