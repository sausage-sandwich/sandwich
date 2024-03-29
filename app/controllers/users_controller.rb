# frozen_string_literal: true

class UsersController < ApplicationController
  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to new_session_url
    else
      render 'new'
    end
  end

  def new; end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
