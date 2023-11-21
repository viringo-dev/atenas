class ChannelsController < ApplicationController
  before_action :set_channel, only: [:mark_as_read]
  before_action :set_channel_user, only: [:mark_as_read]

  def mark_as_read
    if @channel_user.touch(:last_read_at)
      render json: {}, status: :ok
    else
      render json: {}, status: :unprocessable_entity
    end
  end

  private

  def set_channel
    @channel = Channel.find_by(uuid: params[:id])
    unless @channel
      if turbo_frame_request?
        flash[:alert] = t("pages.channels.alerts.not_found")
        render turbo_stream: turbo_stream.action(:redirect, messages_url)
      else
        respond_to do |format|
          format.json { render json: {}, status: :not_found }
          format.html { redirect_to root_path, alert: t("pages.channels.alerts.not_found") }
        end
      end
    end
  end

  def set_channel_user
    @channel_user = current_user.channel_users.find_by(channel: @channel)
    unless @channel_user
      if turbo_frame_request?
        flash[:alert] = t("pages.channels.alerts.not_found")
        render turbo_stream: turbo_stream.action(:redirect, messages_url)
      else
        respond_to do |format|
          format.json { render json: {}, status: :not_found }
          format.html { redirect_to root_path, alert: t("pages.channels.alerts.not_found") }
        end
      end
    end
  end
end
