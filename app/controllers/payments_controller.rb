class PaymentsController < ApplicationController
  before_action :authenticate_user!
  # before_action :set_task, only: [:new, :create, :edit, :update, :destroy]
  # before_action :set_my_task, only: [:index, :accept]
  # before_action :set_my_bid, only: [:edit, :update, :destroy]
  before_action :set_bid, only: [:new, :create]

  def new
    @payment = @bid.build_payment
  end

  def create
    @payment = @bid.build_payment(payment_params)
    if @payment.save
      @bid.paid!
      respond_to do |format|
        format.html { redirect_to tasks_path, notice: t("pages.payments.created") }
        format.turbo_stream { flash.now[:notice] = t("pages.payments.created") }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end
    # @bid = @task.bids.build(bid_params.merge(user: current_user))
    # if @bid.save
    #   respond_to do |format|
    #     format.html { redirect_to tasks_path, notice: t("pages.bids.created") }
    #     format.turbo_stream { flash.now[:notice] = t("pages.bids.created") }
    #   end
    # else
    #   render :new, status: :unprocessable_entity
    # end
  # end

  private

  def payment_params
    params.require(:payment).permit(:payer, :attachment, :bid_id)
  end

  def set_bid
    @bid = Bid.find_by(id: params[:bid_id] || payment_params[:bid_id])

    unless @bid && @bid.accepted? && (@bid.task.user == current_user)
      if turbo_frame_request?
        flash[:alert] = t("pages.bids.alerts.not_found")
        render turbo_stream: turbo_stream.action(:redirect, tasks_url)
      else
        redirect_to tasks_path, alert: t("pages.bids.alerts.not_found")
      end
    end
  end
end
