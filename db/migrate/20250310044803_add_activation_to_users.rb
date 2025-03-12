class AddActivationToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :activation, :string
    add_column :users, :activated, :boolean
    add_column :users, :activated_at, :datetime
  end
end
