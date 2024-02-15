# frozen_string_literal: true

class TaskComponent < ApplicationComponent
  attr_reader :task, :current_user, :bid
  def initialize(task:, current_user: nil)
    @task = task
    @current_user = current_user
  end

  def current_page_is_task_path?
    @current_page_is_task_path ||= current_page?(task_path(task))
  end

  def current_user_can_edit_task?
    Tasks::EditPolicy.new(user: current_user, task: task).allowed?
  end

  def bid
    return unless current_user
    @bid ||= task.bid_by_user(current_user)
  end
end
