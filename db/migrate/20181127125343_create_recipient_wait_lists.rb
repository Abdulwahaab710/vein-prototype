class CreateRecipientWaitLists < ActiveRecord::Migration[5.2]
  def change
    create_table :recipient_wait_lists do |t|
      t.references :user, foreign_key: true
      t.references :blood_type, foreign_key: true

      t.timestamps
    end
  end
end
