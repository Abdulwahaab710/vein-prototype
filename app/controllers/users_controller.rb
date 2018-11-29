# frozen_string_literal: true

class UsersController < ApplicationController
  skip_before_action :user_logged_in?, only: %i[new create]
  skip_before_action :user_confirmed?, only: %i[new create confirm_number_new confirm_number]
  include Sessions

  def create
    @user = User.new(user_params)
    if @user.save
      SendConfirmationCodeJob.perform_later(@user)
      flash[:success] = 'Welcome to Vein, your account has been create'
      return redirect_to login_path
    else
      return render :new, status: :bad_request
    end
  rescue ActionController::ParameterMissing
    flash[:error] = 'Required parameters are missing.'
    render :new, status: :bad_request
  end

  def new
    return redirect_back_or root_path if logged_in?
    @user = User.new
    render :new
  end

  def confirm_number_new
    @user = current_user
  end

  def confirm_number
    if params[:token].to_i == current_user.confirm_token
      current_user.update!(confirmed: true, confirm_token: nil)
      redirect_to complete_profile_path
    else
      flash.now[:danger] = 'Invalid token'
      render :confirm_number_new, status: :bad_request
    end
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
    if current_user.is_donor
      flash[:success] = 'You have successfully opt-out'
      current_user.update!(is_donor: false, is_recipient: false)
    else
      flash[:success] = 'You have successfully opt-in'
      current_user.update!(is_donor: true, is_recipient: false)
      FindRecipientOrDonarJob.perform_later(current_user, f_recipient: true)
    end
    redirect_to action: :status
  end

  def register_as_a_blood_recipient
    return blood_recipient_already_register unless current_user.blood_donation_requests.where(fulfilled: false).empty?
    BloodDonationRequest.create!(user: current_user, amount: params[:blood_donation_request][:amount])
    current_user.update!(is_donor: false, is_recipient: true)
    FindRecipientOrDonarJob.perform_later(current_user, f_donor: true, amount: params[:blood_donation_request][:amount])
    flash[:success] = 'Your request has been register'
    redirect_to root_path
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

  def blood_recipient_already_register
    flash[:danger] = 'You have already been enrolled as a blood recipient'
    redirect_to root_path
  end
end
