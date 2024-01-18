class Payments::CreatePolicy < ApplicationPolicy
  attr_reader :user, :bid
  def initialize(user:, bid:)
    @user = user
    @bid = bid
  end

  def allowed?
    task_belongs_to_user? && task.unpaid? && bid.offered? && bid_have_no_payment?
  end

  private

  def task
    @task ||= bid.task
  end

  def task_belongs_to_user?
    task.user == user
  end

  def bid_have_no_payment?
    bid.reload
    bid.payment.nil?
  end
end
