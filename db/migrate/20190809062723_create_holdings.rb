class CreateHoldings < ActiveRecord::Migration[5.2]
  def change
    create_table :holdings do |t|
      t.references :user, foreign_key: true
      t.references :company, foreign_key: true

      t.timestamps
      t.index [:user_id, :company_id], unique: true
    end
  end
end
