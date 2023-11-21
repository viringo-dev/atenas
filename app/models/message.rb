class Message < ApplicationRecord
  ## ASSOCIATIONS ##
  belongs_to :channel
  belongs_to :user

  ## VALIDATIONS ##
  validates :content, presence: { allow_blank: false, message: :blank }

  ## CALLBACKS ##
  after_create_commit -> { broadcast_append_later_to channel, partial: "channels/message", target: channel }

  ## SCOPES ##
  scope :paginated, ->(params={}) { page(params[:page]).per(params[:per_page]) }
end
