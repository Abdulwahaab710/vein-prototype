# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include Sessions
  before_action :user_logged_in?
  before_action :user_confirmed?

  private

  def user_logged_in?
    return if logged_in?
    store_location
    flash[:danger] = 'Please log in.'
    redirect_to login_url
  end

  def user_confirmed?
    return redirect_to confirm_user_number_path unless current_user.confirmed?
  end
end
