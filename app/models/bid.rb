class Bid < ApplicationRecord

  ## ASSOCIATIONS ##
  belongs_to :user
  belongs_to :task
  has_one :payment, dependent: :nullify

  ## VALIDATIONS ##
  validates :amount, presence: { allow_blank: false, message: :blank }, numericality: { only_float: true, greater_than: 0 }
  validates :user, uniqueness: { scope: :task, message: :already_bidded }

  ## ENUMS ##
  enum status: { offered: 0, accepted: 1, paid: 2, transferred: 3 }

  ## SCOPES ##
  scope :ordered, -> { order(created_at: :desc) }
  scope :paginated, ->(params={}) { page(params[:page]).per(params[:per_page]) }
  scope :by_user, ->(user) { user.present? ? where(user: user) : none }
end
