class AddCodeToStock < ActiveRecord::Migration[5.2]
  def change
    add_column :stocks, :code, :string, null: false
  end
end
