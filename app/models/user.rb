# frozen_string_literal: true

class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d-]+(\.[a-z\d-]+)*\.[a-z]+\z/i.freeze

  has_many :recipes, dependent: :restrict_with_exception
  has_many :tokens, dependent: :nullify
  has_many :password_recovery_tokens, -> { password_recovery },
           class_name: 'Token', inverse_of: :user, dependent: :destroy

  before_validation :downcase_email

  has_secure_password

  validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }

  def downcase_email
    self.email = email.downcase
  end
end
