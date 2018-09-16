# frozen_string_literal: true

class DonationQueuesController < ApplicationController
  skip_before_action :user_logged_in?

  def confirm
    @donation_queue = DonationQueue.find_by!(token: params[:token])
  end

  def available_status
    blood_donation_request = DonationQueue.find_by!(token: params[:token])
    BloodDonation.create(donor_id: blood_donation_request.donor_id, recipient_id: blood_donation_request.recipient_id)
    blood_donation_request.destroy
  end

  def unavailable_status
    blood_donation_request = DonationQueue.find_by!(token: params[:token])
    FindRecipientOrDonarJob.perform_later(
      User.find(blood_donation_request.recipient_id), f_donor: true, donor: blood_donation_request
    )
  end
end
