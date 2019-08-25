class CreateFinancialReports < ActiveRecord::Migration[5.2]
  def change
    create_table :financial_reports do |t|
      t.references :company, foreign_key: true
      t.integer :tcfo
      t.integer :net_income
      t.integer :total_revenue

      t.timestamps
    end
  end
end
