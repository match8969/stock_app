json.extract! financial_report, :id, :tcfo, :net_income, :total_revenue, :created_at, :updated_at
json.url financial_report_url(financial_report, format: :json)
