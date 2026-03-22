# frozen_string_literal: true

class UsersController < ApplicationController
  def new; end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to new_session_url
    else
      render 'new'
    end
  end

  private

  def user_params
    params.expect(user: %i[name email password password_confirmation])
  end
end
