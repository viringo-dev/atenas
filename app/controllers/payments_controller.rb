class PaymentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_bid, only: [:new, :create]
  before_action :can_create_payment?, only: [:new, :create]

  def new
    @payment = @bid.build_payment
  end

  def create
    @payment = @bid.build_payment(payment_params)
    if @payment.save
      respond_to do |format|
        format.html { redirect_to root_path, notice: t("pages.payments.we_going_to_validate") }
        format.turbo_stream do
          flash[:notice] = t("pages.payments.we_going_to_validate")
          render turbo_stream: turbo_stream.action(:redirect, root_path)
        end
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def payment_params
    params.require(:payment).permit(:payer, :attachment, :bid_id, :task_id)
  end

  def set_bid
    @bid = Bid.find_by(id: params[:bid_id] || payment_params[:bid_id])

    unless @bid.present?
      if turbo_frame_request?
        flash[:alert] = t("pages.common.alerts.not_allowed_action")
        render turbo_stream: turbo_stream.action(:redirect, tasks_url)
      else
        redirect_to root_path, alert: t("pages.common.alerts.not_allowed_action")
      end
    end
  end

  def can_create_payment?
    unless Payments::CreatePolicy.new(user: current_user, bid: @bid).allowed?
      if turbo_frame_request?
        flash[:alert] = t("pages.common.alerts.not_allowed_action")
        render turbo_stream: turbo_stream.action(:redirect, tasks_url)
      else
        redirect_to root_path, alert: t("pages.common.alerts.not_allowed_action")
      end
    end
  end
end
