class Avo::Resources::User < Avo::BaseResource
  self.includes = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :name, as: :text
    field :surname, as: :text
    field :username, as: :text
    field :email, as: :text
    field :phone, as: :text
    field :phone_code, as: :text
    field :gender, as: :select, enum: ::User.genders
    field :birthdate, as: :date
    field :locale, as: :text
    field :country, as: :country
    field :city, as: :text
    field :deleted_at, as: :date_time
    field :rgpd_accepted_at, as: :date_time
    field :confirmed_at, as: :date_time
    field :avatar, as: :file
    field :active_sessions, as: :has_many
    field :tasks, as: :has_many
    field :channel_users, as: :has_many
    field :channels, as: :has_many, through: :channel_users
    field :notifications, as: :has_many
  end
end
