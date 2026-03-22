# frozen_string_literal: true

class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:session].fetch(:email))

    if user&.authenticate(params[:session].fetch(:password))
      sign_in(user)

      redirect_to root_path
    else
      render :new
    end
  end

  def destroy
    sign_out

    redirect_to root_path
  end

  private

  def session_params
    params.expect(session: %i[email password])
  end
end
