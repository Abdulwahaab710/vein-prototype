# frozen_string_literal: true

# Session controller
class SessionsController < ApplicationController
  skip_before_action :user_logged_in?, only: %i[new create]
  include Sessions

  def new
    return redirect_back_or root_path if logged_in?
    render :new unless performed?
  end

  def create
    user = find_user
    if !!user&.authenticate(params[:session][:password])
      log_in user
      return redirect_to_complete_your_profile if user.blood_type.nil?
      redirect_back_or root_path
    else
      flash.now[:danger] = 'Invalid email or phone/password combination'
      render 'new', status: :unauthorized
    end
  end

  def destroy
    @current_session = Session.find_by(id: session[:user_session_id])
    @current_session.destroy
    session[:session_id] = nil
    redirect_to login_path
  end

  private

  def find_user
    return User.find_by(email: params[:session][:email]) if email? params[:session][:email]
    User.find_by(phone: params[:session][:email])
  end

  def email?(email)
    email =~ /[A-Za-z0-9\.]+@[A-Za-z0-9\.]+/
  end

  def redirect_to_complete_your_profile
    redirect_to complete_profile_path
  end
end
