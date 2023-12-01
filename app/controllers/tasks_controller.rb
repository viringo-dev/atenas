class TasksController < ApplicationController
  before_action :set_my_task, only: [:edit, :update, :destroy]
  before_action :set_task, only: [:show]
  before_action :authenticate_user!, only: [:new]
  before_action :can_edit_task?, only: [:edit, :update, :destroy]

  def index
    @pagy, @tasks = pagy(Task.bided
                             .ordered
                             .includes(:files_attachments, :bids, user: :avatar_attachment))
  end

  def my_tasks
    @pagy, @tasks = pagy(current_user.tasks
                                     .bided
                                     .ordered
                                     .includes(:files_attachments))
  end

  def my_bids
    @pagy, @tasks = pagy(Task.ordered
                             .with_bids_by(current_user)
                             .includes(:files_attachments, :bids, user: :avatar_attachment))
  end
  
  def new
    @task = Task.new(deadline: Date.current + 1.week)
  end

  def show
    @bids = @task.user == current_user ? @task.bids : @task.bids.by_user(current_user)
    @bids = @bids.includes(user: :avatar_attachment)
  end

  def create
    @task = current_user.tasks.build(task_params)
    if @task.save
      respond_to do |format|
        format.html { redirect_to root_path, notice: t("pages.tasks.created") }
        format.turbo_stream { flash.now[:notice] = t("pages.tasks.created") }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @task.update(task_params)
      respond_to do |format|
        format.html { redirect_to root_path, notice: t("pages.tasks.updated") }
        format.turbo_stream { flash.now[:notice] = t("pages.tasks.updated") }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to root_path, notice: t("pages.tasks.deleted") }
      format.turbo_stream { flash.now[:notice] = t("pages.tasks.deleted") }
    end
  end

  private

  def task_params
    params.require(:task).permit(:name, :description, :reward, :deadline, files: [])
  end

  def set_my_task
    @task = current_user.tasks.find_by(id: params[:id])
    unless @task
      if turbo_frame_request?
        flash[:alert] = t("pages.tasks.alerts.not_found")
        render turbo_stream: turbo_stream.action(:redirect, tasks_url)
      else
        redirect_to root_path, alert: t("pages.tasks.alerts.not_found")
      end
    end
  end

  def set_task
    @task = Task.find_by(id: params[:id])
    unless @task
      if turbo_frame_request?
        flash[:alert] = t("pages.tasks.alerts.not_found")
        render turbo_stream: turbo_stream.action(:redirect, tasks_url)
      else
        redirect_to root_path, alert: t("pages.tasks.alerts.not_found")
      end
    end
  end

  def can_edit_task?
    unless Tasks::EditPolicy.new(user: current_user, task: @task).allowed?
      if turbo_frame_request?
        flash[:alert] = t("pages.common.alerts.not_allowed_action")
        render turbo_stream: turbo_stream.action(:redirect, task_url(@task))
      else
        redirect_to task_url(@task), alert: t("pages.common.alerts.not_allowed_action")
      end
    end
  end
end
