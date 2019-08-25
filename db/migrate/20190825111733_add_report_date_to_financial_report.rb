class AddReportDateToFinancialReport < ActiveRecord::Migration[5.2]
  def change
    add_column :financial_reports, :report_date, :datetime
  end
end
