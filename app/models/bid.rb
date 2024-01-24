class Bid < ApplicationRecord
  include Ownerable

  TAX = 0.1
  ## ASSOCIATIONS ##
  belongs_to :user
  belongs_to :task
  has_one :payment, dependent: :nullify
  has_one :cashout, dependent: :nullify
  has_many :notifications, as: :resource, dependent: :destroy
  has_many :rates, dependent: :destroy

  ## VALIDATIONS ##
  validates :amount, presence: { allow_blank: false, message: :blank }, numericality: { only_float: true, greater_than: 0 }
  validates :user, uniqueness: { scope: :task, message: :already_bidded }

  ## CALLBACKS ##
  before_save :set_earning
  after_create_commit { NotificationJob.perform_later(self.id, Notification.notification_types[:new_bid]) }

  ## ENUMS ##
  enum status: { offered: 0, accepted: 1, finished: 2, paid: 3 }

  ## SCOPES ##
  scope :ordered, -> { order(created_at: :desc) }
  scope :paginated, ->(params={}) { page(params[:page]).per(params[:per_page]) }
  scope :by_user, ->(user) { user.present? ? where(user: user) : none }

  def has_payment?
    payment.present?
  end

  def has_owner_rate?
    rates.task_owner.exists?
  end

  def has_assignee_rate?
    rates.task_assignee.exists?
  end

  private

  def set_earning
    self.earning = (amount * (1 - TAX)).round(2)
  end
end
