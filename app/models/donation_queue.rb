# frozen_string_literal: true

class DonationQueue < ApplicationRecord
  belongs_to :user, optional: true
  before_create { generate_token }

  private

  def generate_token
    self.token = loop do
      random_token = SecureRandom.urlsafe_base64(nil, false)
      break random_token unless self.class.exists?(token: random_token)
    end
  end
end
