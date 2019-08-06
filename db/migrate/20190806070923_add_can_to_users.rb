class AddCanToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :can, :integer, default: 0
  end
end
