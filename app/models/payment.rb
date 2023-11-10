class Payment < ApplicationRecord
  ## ASSOCIATIONS ##
  belongs_to :bid
  has_one_attached :attachment

  ## VALIDATIONS ##
  validates :payer, presence: { allow_blank: false }
end
