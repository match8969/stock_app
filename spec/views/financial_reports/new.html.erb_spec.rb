require 'rails_helper'

RSpec.describe "financial_reports/new", type: :view do
  before(:each) do
    assign(:financial_report, FinancialReport.new(
      :tcfo => 1,
      :net_income => 1,
      :total_revenue => 1
    ))
  end

  it "renders new financial_report form" do
    render

    assert_select "form[action=?][method=?]", financial_reports_path, "post" do

      assert_select "input[name=?]", "financial_report[tcfo]"

      assert_select "input[name=?]", "financial_report[net_income]"

      assert_select "input[name=?]", "financial_report[total_revenue]"
    end
  end
end
