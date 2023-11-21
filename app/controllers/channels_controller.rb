class ChannelsController < ApplicationController
  before_action :set_channel, only: [:index]

  def index
    @channels = current_user.channels
    if @channel.present?
      @messages = @channel.messages.includes(:user)
    end
  end

  private

  def set_channel
    @channel = Channel.find_by(uuid: params[:uuid])
  end
end
