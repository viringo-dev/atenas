class Notification < ApplicationRecord
  ## ASSOCIATIONS ##
  belongs_to :resource, polymorphic: true
  belongs_to :user

  ## VALIDATIONS ##
  validates :user, presence: { allow_blank: false }
  validates :resource, presence: { allow_blank: false }

  ## ENUMS ##
  enum type: { new_bid: 0
             }

  ## SCOPES ##
  scope :unreaded, -> { where(readed: false) }
end
