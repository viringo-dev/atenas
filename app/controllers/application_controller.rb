class ApplicationController < ActionController::Base
  include Authentication
  include Pagy::Backend
  before_action :authenticate_user!
  before_action :set_channels, if: :user_signed_in?
  helper_method :are_there_unread_notifications?

  private

  def set_channels
    @channels = Channel.with_unread_messages_count_by(current_user)
  end

  def are_there_unread_notifications?
    current_user.notifications.unread.any?
  end

  def redirect_to_root_if_not_turbo_frame_request
    redirect_to root_path unless turbo_frame_request?
  end
end
