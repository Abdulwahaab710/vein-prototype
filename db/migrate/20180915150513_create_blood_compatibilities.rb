# frozen_string_literal: true

class CreateBloodCompatibilities < ActiveRecord::Migration[5.2]
  def change
    create_table :blood_compatibilities do |t|
      t.references :donator, foreign_key: { to_table: :blood_types }
      t.references :receiver, foreign_key: { to_table: :blood_types }

      t.timestamps
    end
  end
end
