class NotificationsController < ApplicationController
  before_action :set_notification, only: [:mark_as_read]

  def index
    current_user.notifications.unreaded.touch_all(:readed)
    @pagy, @notifications = pagy(current_user.notifications.includes(resource: [:user, :task]), items: 10)
  end

  def mark_as_read
    if @notification.touch(:readed)
      render json: {}, status: :ok
    else
      render json: {}, status: :unprocessable_entity
    end
  end

  private

  def set_notification
    @notification = current_user.notifications.find_by(id: params[:id])
    unless @notification
      if turbo_frame_request?
        flash[:alert] = t("pages.notifications.alerts.not_found")
        render turbo_stream: turbo_stream.action(:redirect, notifications_url)
      else
        respond_to do |format|
          format.json { render json: {}, status: :not_found }
          format.html { redirect_to root_path, alert: t("pages.notifications.alerts.not_found") }
        end
      end
    end
  end
end
