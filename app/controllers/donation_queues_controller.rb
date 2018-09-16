# frozen_string_literal: true

class DonationQueuesController < ApplicationController
  def confirm; end

  def available_status
    blood_donation_request = BloodDonationRequest.find_by(token: params[:token])
    BloodDonation.create(donor: blood_donation_request.donor, recipient: blood_donation_request.recipient)
    blood_donation_request.destroy
  end

  def unavailable_status
    blood_donation_request = BloodDonationRequest.find_by(token: params[:token])
    FindRecipientOrDonarJob.perform_later(blood_donation_request.recipient, f_donor: true)
    blood_donation_request.destroy
  end
end
