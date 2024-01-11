class NotificationsController < ApplicationController
  before_action :set_notification, only: [:mark_as_read, :show]

  def index
    current_user.notifications.unread.touch_all(:readed)
    @pagy, @notifications = pagy(current_user.notifications
                                             .ordered
                                             .includes(resource: [:user, :task]), items: 10)
  end

  def show
    @notification.touch(:readed)
    redirect_to @notification.path
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
          format.html { redirect_to notifications_path, alert: t("pages.notifications.alerts.not_found") }
        end
      end
    end
  end
end
