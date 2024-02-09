class ApplicationComponent < ViewComponent::Base
  include Turbo::StreamsHelper
  include ApplicationHelper

  def current_user
    Current.user
  end
end
