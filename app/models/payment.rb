class Payment < ApplicationRecord
  ## CONSTANTS ##
  MAX_ATTACHMENT_SIZE = 3

  ## ASSOCIATIONS ##
  belongs_to :task
  belongs_to :bid
  has_one_attached :attachment

  ## VALIDATIONS ##
  validates :payer, presence: { allow_blank: false }
  validates :bid, uniqueness: true
  validate :attachment_size

  ## ENUMS ##
  enum status: { pending: 0, validated: 1, rejected: 2 }

  def validate!
    Payments::ValidateService.new(payment: self).call
  end

  private

  def attachment_size
    if attachment.attached? && attachment.blob.byte_size > MAX_ATTACHMENT_SIZE.megabytes
      attachment.purge
      errors.add(:attachment, :too_big, max_size: MAX_ATTACHMENT_SIZE)
    end
  end
end
