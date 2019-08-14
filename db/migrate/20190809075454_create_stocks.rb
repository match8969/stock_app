class CreateStocks < ActiveRecord::Migration[5.2]
  def change
    create_table :stocks do |t|
      t.references :company, foreign_key: true
      t.references :market, foreign_key: true
      t.integer :status, default: 1

      t.timestamps
    end
  end
end
