# frozen_string_literal: true

module ApplicationHelper
  def current_user
    return unless session[:user_id]

    @current_user ||= User.find(session[:user_id])
  end

  def sign_in(user)
    session[:user_id] = user.id
  end

  def sign_out
    session[:user_id] = nil
  end

  def signed_in?
    current_user.present?
  end

  def active_link_class(link)
    return '' unless current_page?(link)

    'active'
  end
end
