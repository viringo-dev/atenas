class CashoutsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_cashout, only: [:new, :create]
  before_action :can_create_cashout?, only: [:new, :create]

  def new
    @cashout = @bid.build_cashout
  end

  def create
    @cashout = @bid.build_cashout(cashout_params)
    if @cashout.save
      respond_to do |format|
        format.html { redirect_to task_path(@bid.task), notice: t("pages.cashout.notification_message") }
        format.turbo_stream do
          flash[:notice] = t("pages.cashout.notification_message")
          render turbo_stream: turbo_stream.action(:redirect, task_path(@bid.task))
        end
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def cashout_params
    params.require(:cashout).permit(:task_id, :bid_id, :phone, :wallet)
  end

  def set_cashout
    @bid = Bid.find_by(id: params[:bid_id] || cashout_params[:bid_id])

    unless @bid.present?
      if turbo_frame_request?
        flash[:alert] = t("pages.common.alerts.not_allowed_action")
        render turbo_stream: turbo_stream.action(:redirect, tasks_url)
      else
        redirect_to root_path, alert: t("pages.common.alerts.not_allowed_action")
      end
    end
  end

  def can_create_cashout?
    unless Cashouts::CreatePolicy.new(user: current_user, bid: @bid).allowed?
      if turbo_frame_request?
        flash[:alert] = t("pages.common.alerts.not_allowed_action")
        render turbo_stream: turbo_stream.action(:redirect, tasks_url)
      else
        redirect_to root_path, alert: t("pages.common.alerts.not_allowed_action")
      end
    end
  end
end
