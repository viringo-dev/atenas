class Channel < ApplicationRecord
  ## ASSOCIATIONS ##
  belongs_to :task
  has_many :messages, dependent: :destroy
  has_many :channel_users, dependent: :destroy

  ## VALIDATIONS ##
  validates :task, presence: { allow_blank: false }
end
