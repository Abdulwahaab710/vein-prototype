class AddFulfilledToBloodDonationRequest < ActiveRecord::Migration[5.2]
  def change
    add_column :blood_donation_requests, :fulfilled, :boolean
  end
end
