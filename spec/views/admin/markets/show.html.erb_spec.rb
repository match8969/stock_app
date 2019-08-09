require 'rails_helper'

RSpec.describe "admin/markets/show", type: :view do
  before(:each) do
    @admin_market = assign(:admin_market, Admin::Market.create!(
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
  end
end
