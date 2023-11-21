class Message < ApplicationRecord
  ## ASSOCIATIONS ##
  belongs_to :channel
  belongs_to :user

  ## VALIDATIONS ##
  validates :content, presence: { allow_blank: false, message: :blank }

  ## CALLBACKS ##
  after_create_commit -> { broadcast_prepend_later_to channel.uuid, partial: "messages/message", target: channel.uuid }

  ## SCOPES ##
  scope :ordered, ->(order = :asc) { order(created_at: order) }
  scope :paginated, ->(params={}) { page(params[:page]).per(params[:per_page]) }
end
