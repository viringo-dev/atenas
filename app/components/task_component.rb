# frozen_string_literal: true

class TaskComponent < ApplicationComponent
  attr_reader :task, :current_user
  def initialize(task:, current_user: nil)
    @task = task
    @current_user = current_user
  end

  def current_page_is_task_path?
    @current_page_is_task_path ||= current_page?(task_path(task))
  end
end
