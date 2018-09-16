# frozen_string_literal: true

class CreateBloodDonations < ActiveRecord::Migration[5.2]
  def change
    create_table :blood_donations do |t|
      t.references :donor, foreign_key: { to_table: :users }
      t.references :recipient, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
