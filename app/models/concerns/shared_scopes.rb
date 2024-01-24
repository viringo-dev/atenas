module SharedScopes
  extend ActiveSupport::Concern

  included do
    scope :ordered, -> { order(created_at: :desc) }
    scope :paginated, ->(params={}) { page(params[:page]).per(params[:per_page]) }
  end
end
