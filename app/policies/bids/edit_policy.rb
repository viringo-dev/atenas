class Bids::EditPolicy < ApplicationPolicy
  attr_reader :user, :bid
  def initialize(user:, bid:)
    @user = user
    @bid = bid
  end

  def allowed?
    user_is_bid_owner? && bid.offered? && task_is_bidable? 
  end

  private

  def user_is_bid_owner?
    user == bid.user
  end

  def task_is_bidable?
    task = bid.task
    task.bided? || task.paused?
  end
end
