class Task < ApplicationRecord
  include Ownerable
  include SharedScopes

  ## ASSOCIATIONS ##
  belongs_to :user
  has_many_attached :files
  has_many :bids, dependent: :destroy
  has_one :channel, dependent: :nullify
  has_one :payment, dependent: :nullify
  has_one :cashout, dependent: :nullify
  has_many :ratings, dependent: :destroy

  ## VALIDATIONS ##
  validates :name, presence: { allow_blank: false, message: :blank }
  validates :description, presence: { allow_blank: false, message: :blank }
  validates :reward, presence: { allow_blank: false, message: :blank }, numericality: { only_float: true, greater_than: 0 }
  validates :deadline, presence: { allow_blank: false, message: :blank }

  ## ENUMS ##
  enum currency: { pen: 0, usd: 1 }
  enum status: { bided: 0, paused: 1, unpaid: 2, assigned: 3, finished: 4, unfinished: 5 }

  ## SCOPES ##
  scope :with_bids_by, ->(user) { includes(:bids).where(bids: { user: user }) }

  def has_payment?
    payment.present?
  end

  def bid_by_user(user)
    bids.find { |bid| bid.user_id == user.id }
  end

  def assignee
    bids.where.not(status: Bid.statuses[:offered])
        .first
        &.user
  end

  def assigned_bid
    bids.where.not(status: Bid.statuses[:offered])
        .first
  end
end
