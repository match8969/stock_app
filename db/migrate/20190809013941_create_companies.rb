class CreateCompanies < ActiveRecord::Migration[5.2]
  def change
    create_table :companies do |t|
      t.string :name
      t.references :industry
      t.references :country

      t.timestamps
    end
  end
end
