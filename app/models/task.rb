class Task < ApplicationRecord

  ## ASSOCIATIONS ##
  belongs_to :user
  has_many_attached :files
  has_many :bids, dependent: :destroy

  ## VALIDATIONS ##
  validates :name, presence: { allow_blank: false, message: :blank }
  validates :description, presence: { allow_blank: false, message: :blank }
  validates :reward, presence: { allow_blank: false, message: :blank }, numericality: { only_float: true }
  validates :deadline, presence: { allow_blank: false, message: :blank }

  ## ENUMS ##
  enum currency: { pen: 0, usd: 1 }
  enum status: { bided: 0, paused: 2, assigned: 1, finished: 3, unfinished: 4 }

  ## SCOPES ##
  scope :ordered, -> { order(created_at: :desc) }
  scope :paginated, ->(params={}) { page(params[:page]).per(params[:per_page]) }
  scope :with_bids_by, ->(user) { includes(:bids).where(bids: { user: user }) }

  def bid_by_user(user)
    bids.find { |bid| bid.user_id == user.id }
  end
end
