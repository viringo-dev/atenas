class Ratings::CreatePolicy < ApplicationPolicy
  attr_reader :user, :bid
  def initialize(user:, bid:)
    @user = user
    @bid = bid
  end

  def allowed?
    task.finished? && bid.paid? &&
    ((user_is_task_owner? && owner_have_no_rated_task?) || (user_is_task_assignee? && assignee_have_no_rated_task?))
  end

  private

  def task
    @task ||= bid.task
  end

  def user_is_task_owner?
    task.user == user
  end

  def owner_have_no_rated_task?
    !bid.has_owner_rate?
  end

  def user_is_task_assignee?
    bid.user == user
  end

  def assignee_have_no_rated_task?
    !bid.has_assignee_rate?
  end
end
