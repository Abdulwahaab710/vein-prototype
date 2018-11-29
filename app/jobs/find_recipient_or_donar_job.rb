# frozen_string_literal: true

class FindRecipientOrDonarJob < ApplicationJob
  queue_as :default

  def perform(user, f_recipient: nil, f_donor: nil, donor: nil, amount: 1)
    return nil if f_recipient.nil? && f_donor.nil?
    @amount = amount
    @user = user
    find_recipient if f_recipient
    find_donor if f_donor
  end

  private

  def send_sms_or_add_to_waitlist(recipient)
    return RecipientWaitList.create(user: recipient) unless donors.count.positive?
    donor = donors.first
    donation_queue = add_to_queue(donor)
    send_sms(donor, donation_queue)
  end

  def add_to_queue(donor)
    DonationQueue.create!(donor_id: donor.id, recipient_id: @user.id)
  end

  def send_sms(user, donation_queue)
    client = Twilio::REST::Client.new
    client.messages.create(
      from: ENV['TWILIO_PHONE_NUMBER'],
      to: user.phone,
      body: "Hey #{user.name}, You have been matched with a recipient."\
      "Please visit #{confirm_donation_url(donation_queue.token)} to confirm"\
      'if you are available to donate'
    )
  end

  def find_recipient
    User.where(city: @user.city, country: @user.country, is_recipient: true).where(
      blood_type_id: @user.blood_type.can_donate_to
    )
  end

  def find_donor
    @amount.to_i.times do
      send_sms_or_add_to_waitlist(@user.phone)
    end
  end

  def donors
    User.where(city: @user.city, country: @user.country, is_donor: true).where(
      blood_type_id: @user.blood_type.can_receive_from
    ).where.not(id: DonationQueue.pluck(:donor_id))
  end

  def confirm_donation_url(token)
    Rails.application.routes.url_helpers.confirm_donation_url(token)
  end
end
