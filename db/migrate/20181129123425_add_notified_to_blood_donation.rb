class AddNotifiedToBloodDonation < ActiveRecord::Migration[5.2]
  def change
    add_column :blood_donations, :notified, :boolean
  end
end
