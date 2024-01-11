class Avo::Resources::Bid < Avo::BaseResource
  self.includes = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :task_id, as: :id
    field :user, as: :belongs_to
    field :amount, as: :text
    field :earning, as: :text
    field :description, as: :text
    field :status, as: :select, enum: ::Bid.statuses
    field :created_at, as: :date_time
  end
end
