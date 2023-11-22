class ApplicationController < ActionController::Base
  include Authentication
  before_action :authenticate_user!
  before_action :set_channels, if: :user_signed_in?

  private

  def set_channels
    @channels = Channel.with_unread_messages_count_by(current_user)
  end
end
