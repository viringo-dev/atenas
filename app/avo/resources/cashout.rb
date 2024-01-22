class Avo::Resources::Cashout < Avo::BaseResource
  self.includes = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :task_id, as: :text
    field :bid_id, as: :text
    field :phone, as: :text
    field :wallet, as: :select, enum: ::Cashout.wallets
    field :status, as: :select, enum: ::Cashout.statuses
    field :attachment, as: :file
  end

  def actions
    action Avo::Actions::ValidateCashout
  end
end
