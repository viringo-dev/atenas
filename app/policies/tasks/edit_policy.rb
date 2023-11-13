class Tasks::EditPolicy < ApplicationPolicy
  attr_reader :user, :task
  def initialize(user:, task:)
    @user = user
    @task = task
  end

  def allowed?
    user_is_task_owner? && (task.bided? || task.paused?)
  end

  private

  def user_is_task_owner?
    user == task.user
  end
end
