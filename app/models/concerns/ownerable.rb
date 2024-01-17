module Ownerable
  extend ActiveSupport::Concern

  def owner?(user)
    self.user == user
  end
end
