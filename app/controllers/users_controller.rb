# frozen_string_literal: true

class UsersController < ApplicationController
  skip_before_action :user_logged_in?, only: %i[new create]
  include Sessions

  def create
    @user = User.new(user_params)
    return render :new, status: :bad_request unless @user.save
    flash[:success] = 'Welcome to Vein, your account has been create'
    redirect_to login_path
  rescue ActionController::ParameterMissing
    flash[:error] = 'Required parameters are missing.'
    render :new, status: :bad_request
  end

  def new
    return redirect_back_or root_path if logged_in?
    @user = User.new
    render :new
  end

  def complete_profile
    @user = current_user
    @blood_types = BloodType.pluck(:name, :id)
  end

  def update
    flash[:success] = 'You have successfully updated your profile' if current_user.update!(user_info_params)
    redirect_to action: :complete_profile
  end

  def status
    render 'status'
  end

  def register_as_a_donar
    current_user.update(is_donor: true, is_recipient: false)
    FindRecipientOrDonarJob.perform_later(current_user, find_recipient: true)
  end

  def register_as_a_blood_recipient
    BloodDonationRequest.create!(user: current_user, amount: params[:blood_donation_request][:amount])
    current_user.update(is_donor: false, is_recipient: true)
    FindRecipientOrDonarJob.perform_later(current_user, f_donor: true)
  end

  def enroll_blood_recipient
    @blood_donation_request = BloodDonationRequest.new
    render 'enroll_blood_recipient'
  end

  private

  def user_params
    params.require(:user).permit(:name, :phone, :email, :password, :password_confirmation)
  end

  def user_info_params
    params.require(:user).permit(
      :address,
      :city,
      :country,
      :blood_type_id
    )
  end
end
