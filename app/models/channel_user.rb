class ChannelUser < ApplicationRecord
  ## ASSOCIATIONS ##
  belongs_to :channel
  belongs_to :user
end
