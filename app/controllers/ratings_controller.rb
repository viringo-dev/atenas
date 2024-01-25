class RatingsController < ApplicationController
  before_action :redirect_to_root_if_not_turbo_frame_request, only: [:new, :edit]
  before_action :authenticate_user!
  before_action :set_bid, only: [:new, :create]
  before_action :can_create_rating?, only: [:create]

  def new
    @rating = @bid.ratings.build
  end

  def create
    @rating = @bid.ratings.build(rating_params)
    if @rating.save
      respond_to do |format|
        format.html { redirect_to task_path(@bid.task), notice: t("pages.ratings.created") }
        format.turbo_stream { render turbo_stream: turbo_stream.action(:redirect, task_path(@bid.task))}
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def rating_params
    params.require(:rating)
          .permit(:value, :comment, :rating_type)
          .merge(user: @bid.owner?(current_user) ? @bid.task.user : @bid.user, task: @bid.task, rater: current_user)
  end

  def set_bid
    @bid = Bid.find(params[:bid_id])
    unless @bid
      if turbo_frame_request?
        flash[:alert] = t("pages.bids.alerts.not_found")
        render turbo_stream: turbo_stream.action(:redirect, task_path(@bid.task))
      else
        redirect_to root_path, alert: t("pages.bids.alerts.not_found")
      end
    end
  end

  def can_create_rating?
    unless Ratings::CreatePolicy.new(user: current_user, bid: @bid).allowed?
      if turbo_frame_request?
        flash[:alert] = t("pages.common.alerts.not_allowed_action")
        render turbo_stream: turbo_stream.action(:redirect, task_path(@bid.task))
      else
        redirect_to root_path, alert: t("pages.common.alerts.not_allowed_action")
      end
    end
  end
end
