# frozen_string_literal: true

class PasswordRecoveryForm
  include ActiveModel::Validations

  attr_reader :email

  def initialize(params = {})
    @email = params.fetch(:email, nil)
  end

  validate :check_user_presence

  def check_user_presence
    return if user.present?

    errors.add(:base, I18n.t('passwords.errors.no_user_with_this_email'))
  end

  def user
    return @user if defined?(@user)

    @user = User.find_by(email: email)
  end

  def all_error_messages
    errors.full_messages.join(', ')
  end
end
