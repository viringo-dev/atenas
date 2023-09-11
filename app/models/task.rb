class Task < ApplicationRecord

  ## ASSOCIATIONS ##
  belongs_to :owner, class_name: "User", foreign_key: "owner_id"
  belongs_to :assignee, class_name: "User", foreign_key: "assignee_id", optional: true

  ## VALIDATIONS ##
  validates :name, presence: { allow_blank: false, message: :blank }
  validates :description, presence: { allow_blank: false, message: :blank }
  validates :reward, presence: { allow_blank: false, message: :blank }, numericality: { only_float: true }
  validates :deadline, presence: { allow_blank: false, message: :blank }

  ## ENUMS ##
  enum currency: { pen: 0, usd: 1 }
  enum status: { bided: 0, accepted: 1, paused: 2, finished: 3, unfinished: 4 }

  ## SCOPES ##
  scope :ordered, -> { order(created_at: :desc) }
end
