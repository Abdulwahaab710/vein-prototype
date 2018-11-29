class AddConfirmTokenToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :confirm_token, :integer
  end
end
