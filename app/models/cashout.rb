class Cashout < ApplicationRecord
  ## ASSOCIATIONS ##
  belongs_to :task
  belongs_to :bid

  ## VALIDATIONS ##
  validates :phone, presence: { allow_blank: false }
  validates :wallet, presence: { allow_blank: false }
  validates :task, uniqueness: true
  validates :bid, uniqueness: true

  ## ENUMS ##
  enum wallet: { yape: 0, plin: 1 }
  enum status: { pending: 0, transferred: 1, unavailable: 2 }
end
