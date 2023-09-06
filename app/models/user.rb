class User < ApplicationRecord
  CONFIRMATION_TOKEN_EXPIRATION = 30.minutes
  MAILER_FROM_EMAIL = "no-reply@atenas.com"
  PASSWORD_RESET_TOKEN_EXPIRATION = 10.minutes

  has_secure_password

  ## ASSOCIATIONS ##
  has_many :active_sessions, dependent: :destroy
  has_many :tasks, foreign_key: "owner_id", dependent: :destroy
  has_many :assigned_tasks, class_name: "Task", foreign_key: "assignee_id", dependent: :destroy
  
  validates :name, presence: { allow_blank: false }
  validates :surname, presence: { allow_blank: false }
  validates :birthdate, presence: { allow_blank: false }
  validates :gender, presence: { allow_blank: false }
  validates :username, presence: { allow_blank: false }, uniqueness: { case_sensitive: false }, format: { with: /\A[a-zA-Z0-9_]+\Z/ }
  validates :email, presence: { allow_blank: false }, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone, presence: { allow_blank: false }, numericality: { only_integer: true }
  validates :password, presence: { allow_blank: false }, length: { minimum: 8 }, format: { with: /\A^(?=.*[a-zA-Z])(?=.*[0-9]).{8,}\z/ }, if: :password_required?

  ## CALLBACKS ##
  before_save :downcase_email

  ## ENUMS ##
  enum gender: { male: 0, female: 1, other: 2 }

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
