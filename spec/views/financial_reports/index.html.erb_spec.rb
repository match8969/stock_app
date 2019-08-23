require 'rails_helper'

RSpec.describe "financial_reports/index", type: :view do
  before(:each) do
    assign(:financial_reports, [
      FinancialReport.create!(
        :tcfo => 2,
        :net_income => 3,
        :total_revenue => 4
      ),
      FinancialReport.create!(
        :tcfo => 2,
        :net_income => 3,
        :total_revenue => 4
      )
    ])
  end

  it "renders a list of financial_reports" do
    render
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
    assert_select "tr>td", :text => 4.to_s, :count => 2
  end
end
