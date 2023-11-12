class BidsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_my_task, only: [:index, :accept]
  before_action :set_my_bid, only: [:edit, :update, :destroy]
  before_action :set_bid, only: [:accept, :payment]

  def index
    @bids = @task.bids.ordered.paginated(params)
  end

  def new
    @bid = @task.bids.build
  end

  def edit
  end

  def create
    @bid = @task.bids.build(bid_params.merge(user: current_user))
    if @bid.save
      respond_to do |format|
        format.html { redirect_to tasks_path, notice: t("pages.bids.created") }
        format.turbo_stream { flash.now[:notice] = t("pages.bids.created") }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @bid.update(bid_params)
      respond_to do |format|
        format.html { redirect_to tasks_path, notice: t("pages.bids.updated") }
        format.turbo_stream { flash.now[:notice] = t("pages.bids.updated") }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @bid.destroy
    respond_to do |format|
      format.html { redirect_to tasks_path, notice: t("pages.bids.deleted") }
      format.turbo_stream { flash.now[:notice] = t("pages.bids.deleted") }
    end
  end

  def accept
    binding.pry
    result = Bids::AcceptService.new(user: current_user, task: @task, bid: @bid).call
    if result.success?
      redirect_to new_payment_path(bid_id: @bid.id)
    else
      redirect_to task_path(@task), alert: t("pages.common.alerts.not_allowed_action")
    end
  end

  private

  def set_task
    @task = Task.find_by(id: params[:task_id])
    unless @task
      if turbo_frame_request?
        flash[:alert] = t("pages.tasks.alerts.not_found")
        render turbo_stream: turbo_stream.action(:redirect, tasks_url)
      else
        redirect_to tasks_path, alert: t("pages.tasks.alerts.not_found")
      end
    end
  end

  def set_my_task
    @task = current_user.tasks.find_by(id: params[:task_id])
    unless @task
      if turbo_frame_request?
        flash[:alert] = t("pages.tasks.alerts.not_found")
        render turbo_stream: turbo_stream.action(:redirect, tasks_url)
      else
        redirect_to tasks_path, alert: t("pages.tasks.alerts.not_found")
      end
    end
  end

  def bid_params
    params.require(:bid).permit(:amount, :description)
  end

  def set_bid
    @bid = Bid.find_by(id: params[:id])
    unless @bid
      if turbo_frame_request?
        flash[:alert] = t("pages.bids.alerts.not_found")
        render turbo_stream: turbo_stream.action(:redirect, tasks_url)
      else
        redirect_to tasks_path, alert: t("pages.bids.alerts.not_found")
      end
    end
  end

  def set_my_bid
    @bid = @task.bids.find_by(id: params[:id], user: current_user)
    unless @bid
      if turbo_frame_request?
        flash[:alert] = t("pages.bids.alerts.not_found")
        render turbo_stream: turbo_stream.action(:redirect, tasks_url)
      else
        redirect_to tasks_path, alert: t("pages.bids.alerts.not_found")
      end
    end
  end
end
