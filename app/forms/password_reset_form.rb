# frozen_string_literal: true

class PasswordResetForm
  include ActiveModel::Validations

  attr_reader :token_value, :password, :password_confirmation

  def initialize(params = {})
    @token_value = params.fetch(:token_value, nil)
    @password = params.fetch(:password, nil)
    @password_confirmation = params.fetch(:password_confirmation, nil)
  end

  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true
  validate :check_user_presence
  validate :check_password_confirmation_valid

  def check_user_presence
    return if token&.user.present?

    errors.add(:base, :invalid)
  end

  def check_password_confirmation_valid
    return if password == password_confirmation

    errors.add(:base, :invalid)
  end

  def token
    return @token if defined?(@token)

    @token = Token.find_by(value: token_value)
  end

  def all_error_messages
    errors.full_messages.join(', ')
  end
end
