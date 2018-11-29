class SendConfirmationCodeJob < ApplicationJob
  queue_as :default

  def perform(user)
    send_sms(user)
  end

  private

  def send_sms(user)
    client = Twilio::REST::Client.new
    client.messages.create(
      from: ENV['TWILIO_PHONE_NUMBER'],
      to: user.phone,
      body: "#{user.confirm_token} is your vein confirmation token"
    )
  end
end
