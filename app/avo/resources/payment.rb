class Avo::Resources::Payment < Avo::BaseResource
  self.includes = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :payer, as: :text
    field :status, as: :select, enum: ::Payment.statuses
    field :bid, as: :belongs_to
    field :attachment, as: :file
    field :created_at, as: :date_time
  end
end
