class CheckDonationRequestJob < ApplicationJob
  queue_as :check_donation

  def perform(user)
    recipient = User.find(user)
    blood_donation_request = BloodDonationRequest.find_by(user: recipient)
    blood_donations = BloodDonation.where(recipient_id: recipient.id)
    byebug
    return unless blood_donation_request.amount.to_i <= blood_donations.count.to_i
    notify_blood_donors(blood_donations&.map(&:donar) ,recipient)
    mark_blood_donation_notified
  end

  private

  def notify_blood_donors(donors, user)
    send_sms(User.find(user))
    donors.each do |donor|
      send_sms(User.find(donor))
    end
  end

  def send_sms(user)
    client = Twilio::REST::Client.new
    client.messages.create(
      from: ENV['TWILIO_PHONE_NUMBER'],
      to: user.phone,
      body: "Hey #{user.name}, Please meet at hospital around around"
    )
  end

  def mark_blood_donation_notified(blood_donation)
    blood_donation.update(notified: true)
  end
end
