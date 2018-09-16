# frozen_string_literal: true

class AddDonorAndRecipientToDonationQueue < ActiveRecord::Migration[5.2]
  def change
    add_reference :donation_queues, :donor, foreign_key: { to_table: :users }
    add_reference :donation_queues, :recipient, foreign_key: { to_table: :users }
    remove_reference :donation_queues, :user
  end
end
