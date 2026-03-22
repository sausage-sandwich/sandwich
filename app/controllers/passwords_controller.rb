# frozen_string_literal: true

class PasswordsController < ApplicationController
  def show
    @form = PasswordRecoveryForm.new
  end

  def recover
    form = PasswordRecoveryForm.new(recover_password_params)
    if form.valid?
      Users::SendPasswordRecoveryToken.call(user: form.user)
      flash[:success] = t('.email_sent', email: form.user.email)

      redirect_to edit_password_path
    else
      flash[:error] = form.all_error_messages
      render :show
    end
  end

  def edit
    @form = PasswordResetForm.new
  end

  def update
    form = PasswordResetForm.new(password_reset_params)
    if form.valid?
      Users::ResetPassword.call(token: form.token, **password_reset_params)
      flash[:success] = t('.password_reset')

      redirect_to new_session_path
    else
      flash[:error] = form.all_error_messages
      render :show
    end
  end

  private

  def recover_password_params
    params.expect(password_reset: [:email])
  end

  def password_reset_params
    params.expect(password_reset: %i[token_value password password_confirmation])
  end
end
