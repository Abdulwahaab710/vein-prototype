class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.string :password_digest
      t.references :blood_type, foreign_key: true
      t.string :address
      t.string :city
      t.string :country

      t.timestamps
    end
  end
end
