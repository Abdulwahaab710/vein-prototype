# frozen_string_literal: true

class BloodDonation < ApplicationRecord
  belongs_to :donor, class_name: 'User', foreign_key: 'donor_id'
  belongs_to :recipient, class_name: 'User', foreign_key: 'recipient_id'
end
