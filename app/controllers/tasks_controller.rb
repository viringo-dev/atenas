class TasksController < ApplicationController
  def index
    @tasks = Task.all.order(created_at: :desc)
  end

  def my_tasks
    @tasks = current_user.tasks
  end
  
  def new
    @task = Task.new
    @task.build_project
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      redirect_to tasks_path, notice: 'Task was successfully created.'
    else
      render action: 'new'
    end
  end

  def edit
    @task = Task.find(params[:id])
    @task.build_project unless @task.project
  end

  def update
    @task = Task.find(params[:id])
    if @task.update_attributes(task_params)
      redirect_to tasks_path, notice: 'Task was successfully updated.'
    else
      render action: 'edit'
    end
  end

  private

  def task_params
    params.require(:task).permit(:name, :description, :project_id, project_attributes: [:name])
  end
end