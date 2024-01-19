class Cashouts::CreatePolicy < ApplicationPolicy
  attr_reader :user, :bid
  def initialize(user:, bid:)
    @user = user
    @bid = bid
  end

  def allowed?
    bid_belongs_to_user? && task.finished? && bid.finished? && bid_have_no_cashout?
  end

  private

  def task
    @task ||= bid.task
  end

  def bid_belongs_to_user?
    bid.user == user
  end

  def bid_have_no_cashout?
    bid.reload
    bid.cashout.nil?
  end
end
