class ApplicationController < ActionController::Base
  include Authentication
  include Pagy::Backend
  before_action :authenticate_user!
  before_action :set_channels, if: :user_signed_in?
  helper_method :are_there_unreaded_notifications?

  private

  def set_channels
    @channels = Channel.with_unread_messages_count_by(current_user)
  end

  def are_there_unreaded_notifications?
    current_user.notifications.unreaded.any?
  end
end
