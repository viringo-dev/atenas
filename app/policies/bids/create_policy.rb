class Bids::CreatePolicy < ApplicationPolicy
  attr_reader :user, :task
  def initialize(user:, task:)
    @user = user
    @task = task
  end

  def allowed?
    task.bided? && task_not_owned_by_user? && task_not_bided_by_user?
  end

  private

  def task_not_owned_by_user?
    user != task.user
  end

  def task_not_bided_by_user?
    !task.bids.by_user(user).exists?
  end
end
