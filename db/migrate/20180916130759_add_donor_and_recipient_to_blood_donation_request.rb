# frozen_string_literal: true

class AddDonorAndRecipientToBloodDonationRequest < ActiveRecord::Migration[5.2]
  def change
    add_reference :blood_donation_requests, :donor, foreign_key: { to_table: :users }
    add_reference :blood_donation_requests, :recipient, foreign_key: { to_table: :users }
  end
end
