class UpdateUserRatingJob < ApplicationJob
  def perform(rating_id)
    rating = Rating.find_by(id: rating_id)
    return unless rating

    user = rating.user
    return unless user

    user.rating = user.ratings.average(:value)
    user.save
  end
end
