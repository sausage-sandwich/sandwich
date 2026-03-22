# frozen_string_literal: true

module Users
  class SendPasswordRecoveryToken
    include Interactor

    delegate :user, to: :context

    def call
      token = user.password_recovery_tokens.create!

      UserMailer.reset_password(token).deliver_now
    end
  end
end
