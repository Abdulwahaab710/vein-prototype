# frozen_string_literal: true

class AddIsDonorAndIsRecipientToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :is_donor, :boolean, default: false
    add_column :users, :is_recipient, :boolean, default: false
  end
end
