class User < ApplicationRecord
  CONFIRMATION_TOKEN_EXPIRATION = 30.minutes
  MAILER_FROM_EMAIL = "no-reply@atenas.app"
  PASSWORD_RESET_TOKEN_EXPIRATION = 10.minutes
  USERNAME_MIN_LENGTH = 3
  USERNAME_MAX_LENGTH = 12

  has_secure_password

  ## ASSOCIATIONS ##
  has_many :active_sessions, dependent: :destroy
  has_many :tasks, dependent: :destroy
  has_one_attached :avatar do |attachable|
    attachable.variant :thumb, resize_to_fill: [128, 128]
    attachable.variant :small, resize_to_fill: [256, 256]
    attachable.variant :medium, resize_to_fill: [512, 512]
    attachable.variant :large, resize_to_fill: [1024, 1024]
  end
  has_many :channel_users, dependent: :nullify
  has_many :channels, through: :channel_users
  has_many :notifications, dependent: :destroy
  has_many :ratings, dependent: :destroy

  ## VALIDATIONS ##
  validates :name, presence: { allow_blank: false }
  validates :surname, presence: { allow_blank: false }
  validates :birthdate, presence: { allow_blank: false }
  validates :gender, presence: { allow_blank: false }
  validates :username, presence: { allow_blank: false }, uniqueness: { case_sensitive: false }, format: { with: /\A[a-zA-Z0-9_]+\Z/ }, length: { minimum: USERNAME_MIN_LENGTH, maximum: USERNAME_MAX_LENGTH }
  validates :email, presence: { allow_blank: false }, uniqueness: { case_sensitive: false }, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }
  validates :phone, presence: { allow_blank: false }, format: { with: /\A\d{1,15}\z/ }
  validates :password, presence: { allow_blank: false }, length: { minimum: 8 }, format: { with: /\A^(?=.*[a-zA-Z])(?=.*[0-9]).{8,}\z/ }, if: :password_required?

  ## CALLBACKS ##
  before_validation :format_fields

  ## ENUMS ##
  enum gender: { male: 0, female: 1, other: 2 }
  enum role: { user: 0, admin: 1 }

  def confirm!
    update_columns(confirmed_at: Time.current)
  end

  def confirmed?
    confirmed_at.present?
  end

  def generate_confirmation_token
    signed_id expires_in: CONFIRMATION_TOKEN_EXPIRATION, purpose: :confirm_email
  end

  def unconfirmed?
    !confirmed?
  end

  def send_confirmation_email!
    confirmation_token = generate_confirmation_token
    UserMailer.confirmation(self, confirmation_token).deliver_now
  end

  def generate_password_reset_token
    signed_id expires_in: PASSWORD_RESET_TOKEN_EXPIRATION, purpose: :reset_password
  end

  def send_password_reset_email!
    password_reset_token = generate_password_reset_token
    UserMailer.password_reset(self, password_reset_token).deliver_now
  end

  def has_unread_notifications?
    notifications.unread.any?
  end

  private

  def password_required?
    new_record? || password.present?
  end

  def format_fields
    self.email = self.email.to_s.strip.downcase
    self.username = self.username.to_s.strip.downcase
    self.phone = self.phone.to_s.strip.downcase
    self.name = self.name.to_s.strip
    self.surname = self.surname.to_s.strip
  end
end
