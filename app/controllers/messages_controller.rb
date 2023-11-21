class MessagesController < ApplicationController
  before_action :set_channel, only: [:create]

  def create
    @message = Message.new(message_params)
    unless @message.save
      render turbo_stream: turbo_stream.action(:redirect, channels_url(uuid: @channel.uuid))
    end
  end

  private

  def set_channel
    @channel = Channel.find_by(id: message_params[:channel_id])
    unless @channel.present?
      if turbo_frame_request?
        flash[:alert] = t("pages.channels.alerts.not_found")
        render turbo_stream: turbo_stream.action(:redirect, channels_url)
      else
        redirect_to root_path, alert: t("pages.channels.alerts.not_found")
      end
    end
  end

  def message_params
    params.require(:message).permit(:content, :channel_id).merge(user: current_user)
  end
end
