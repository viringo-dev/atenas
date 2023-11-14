class Payments::CreatePolicy < ApplicationPolicy
  attr_reader :user, :bid
  def initialize(user:, bid:)
    @user = user
    @bid = bid
  end

  def allowed?
    task_belongs_to_user? && task.unpaid? && bid.accepted? && not_paid_yet?
  end

  private

  def task
    @task ||= bid.task
  end

  def task_belongs_to_user?
    task.user == user
  end

  def not_paid_yet?
    @bid.reload
    @bid.payment.nil?
  end
end
