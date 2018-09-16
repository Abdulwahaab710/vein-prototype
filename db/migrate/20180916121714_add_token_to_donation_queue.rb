class AddTokenToDonationQueue < ActiveRecord::Migration[5.2]
  def change
    add_column :donation_queues, :token, :string
  end
end
