class ApplicationController < ActionController::Base
  include Authentication
  include Pagy::Backend
  before_action :authenticate_user!
  before_action :set_channels, if: :user_signed_in?
  before_action :set_notifications, if: :user_signed_in?

  private

  def set_channels
    @channels = Channel.with_unread_messages_count_by(current_user)
  end

  def set_notifications
    @notifications = current_user.notifications.unreaded
  end
end
