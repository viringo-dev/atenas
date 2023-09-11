class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def index
    @tasks = Task.ordered
  end

  def my_tasks
    @tasks = current_user.tasks.ordered
  end
  
  def new
    @task = Task.new(deadline: Date.current + 1.week)
  end

  def create
    @task = current_user.tasks.build(task_params)
    if @task.save
      respond_to do |format|
        format.html { redirect_to quotes_path, notice: t("pages.tasks.created") }
        format.turbo_stream { flash.now[:notice] = t("pages.tasks.created") }
      end
    else
      render :new, status: :unprocessable_entity
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
    params.require(:task).permit(:name, :description, :reward, :deadline)
  end

  def set_task
    @task = Task.find(params[:id])
  end
end
