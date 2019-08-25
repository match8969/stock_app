require 'rails_helper'

RSpec.describe "financial_reports/show", type: :view do
  before(:each) do
    @financial_report = assign(:financial_report, FinancialReport.create!(
      :tcfo => 2,
      :net_income => 3,
      :total_revenue => 4
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/4/)
  end
end
