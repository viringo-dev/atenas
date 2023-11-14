class Payment < ApplicationRecord
  ## ASSOCIATIONS ##
  belongs_to :bid
  has_one_attached :attachment

  ## VALIDATIONS ##
  validates :payer, presence: { allow_blank: false }
  validates :bid, uniqueness: true

  ## ENUMS ##
  enum status: { pending: 0, validated: 1, rejected: 2 }
end
