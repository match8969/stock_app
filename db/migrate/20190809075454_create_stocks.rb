class CreateStocks < ActiveRecord::Migration[5.2]
  def change
    create_table :stocks do |t|
      t.references :company, foreign_key: true
      t.references :market, foreign_key: true
      t.integer :status

      t.timestamps
    end
  end
end
