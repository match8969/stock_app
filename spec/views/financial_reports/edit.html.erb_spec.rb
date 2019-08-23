require 'rails_helper'

RSpec.describe "financial_reports/edit", type: :view do
  before(:each) do
    @financial_report = assign(:financial_report, FinancialReport.create!(
      :tcfo => 1,
      :net_income => 1,
      :total_revenue => 1
    ))
  end

  it "renders the edit financial_report form" do
    render

    assert_select "form[action=?][method=?]", financial_report_path(@financial_report), "post" do

      assert_select "input[name=?]", "financial_report[tcfo]"

      assert_select "input[name=?]", "financial_report[net_income]"

      assert_select "input[name=?]", "financial_report[total_revenue]"
    end
  end
end
