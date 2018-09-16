# frozen_string_literal: true

class FindRecipientOrDonarJob < ApplicationJob
  queue_as :default

  def perform(user, f_recipient: nil, f_donor: nil)
    return nil if f_recipient.nil? && f_donor.nil?
    @user = user
    find_recipient if f_recipient
    find_donor if f_donor
  end

  private

  def send_sms_or_add_to_waitlist(recipient)
    return RecipientWaitList.create(user: recipient) unless donors.count.positive?
    donor = donors.first
    donation_queue = add_to_queue(donor)
    send_sms(donor.phone, donation_queue)
  end

  def add_to_queue(donor)
    DonationQueue.create(user: donor)
  end

  def send_sms(_phone_number, donation_queue)
    client = Twilio::REST::Client.new
    client.messages.create(
      from: ENV['TWILIO_PHONE_NUMBER'],
      # to: phone_number,
      to: '+16135013175',
      body: 'You have matched with a recipient.'\
      "Please visit https://veinapp.herokuapp.com/confirm/#{donation_queue.token} to confirm if you are available to donate"
    )
  end

  def find_recipient
    User.where(city: @user.city, country: @user.country, is_recipient: true).where(
      blood_type_id: @user.blood_type.can_donate_to
    )
  end

  def find_donor
    send_sms_or_add_to_waitlist('+16135013175')
  end

  def donors
    User.where(city: @user.city, country: @user.country, is_donor: true).where(
      blood_type_id: @user.blood_type.can_receive_from
    )
  end
end
