class User < ApplicationRecord
  CONFIRMATION_TOKEN_EXPIRATION = 30.minutes
  MAILER_FROM_EMAIL = "no-reply@atenas.com"
  PASSWORD_RESET_TOKEN_EXPIRATION = 10.minutes
  USERNAME_MIN_LENGTH = 6
  USERNAME_MAX_LENGTH = 12

  has_secure_password

  ## ASSOCIATIONS ##
  has_many :active_sessions, dependent: :destroy
  has_many :tasks, dependent: :destroy
  has_one_attached :avatar
  has_many :channel_users, dependent: :nullify
  has_many :channels, through: :channel_users
  has_many :notifications, dependent: :destroy
  has_many :rates, dependent: :destroy

  ## VALIDATIONS ##
  validates :name, presence: { allow_blank: false }
  validates :surname, presence: { allow_blank: false }
  validates :birthdate, presence: { allow_blank: false }
  validates :gender, presence: { allow_blank: false }
  validates :username, presence: { allow_blank: false }, uniqueness: { case_sensitive: false }, format: { with: /\A[a-zA-Z0-9_]+\Z/ }, length: { minimum: USERNAME_MIN_LENGTH, maximum: USERNAME_MAX_LENGTH }
  validates :email, presence: { allow_blank: false }, uniqueness: { case_sensitive: false }, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }
  validates :phone, presence: { allow_blank: false }, format: { with: /\A\+\d{1,3} \d{1,15}+\z/ }
  validates :password, presence: { allow_blank: false }, length: { minimum: 8 }, format: { with: /\A^(?=.*[a-zA-Z])(?=.*[0-9]).{8,}\z/ }, if: :password_required?

  ## CALLBACKS ##
  before_save :downcase_email

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

  private

  def password_required?
    new_record? || password.present?
  end

  def downcase_email
    self.email = email.downcase
  end
end
