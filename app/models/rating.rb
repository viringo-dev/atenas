class Rating < ApplicationRecord
  include SharedScopes

  ## ASSOCIATIONS ##
  belongs_to :user
  belongs_to :task
  belongs_to :bid

  ## VALIDATIONS ##
  validates :user, presence: { allow_blank: false }
  validates :task, presence: { allow_blank: false }
  validates :value, presence: { allow_blank: false }, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 5 }
  validates :rating_type, presence: { allow_blank: false }

  ## ENUMS ##
  enum rating_type: { task_owner: 0,
                      task_assignee: 1
                    }
end
