class MessagesController < ApplicationController
  before_action :set_channel, only: [:index, :create]

  def index
    if @channel.present?
      @messages = @channel.messages
                          .ordered(:desc)
                          .paginated(params.merge(per_page: 20))
                          .includes(:user)
      channel_user = current_user.channel_users.find_by(channel: @channel)
      channel_user.touch(:last_read_at) if channel_user.present?
    end
    @channels = current_user.channels
  end

  def create
    @message = Message.new(message_params)
    unless @message.save
      render turbo_stream: turbo_stream.action(:redirect, channels_url(uuid: @channel.uuid))
    end
  end

  private

  def set_channel
    @channel = current_user.channels.find_by(uuid: params[:uuid])
  end

  def message_params
    params.require(:message).permit(:content, :channel_id).merge(user: current_user)
  end
end
