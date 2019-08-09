require 'rails_helper'

RSpec.describe "admin/markets/index", type: :view do
  before(:each) do
    assign(:admin_markets, [
      Admin::Market.create!(
        :name => "Name"
      ),
      Admin::Market.create!(
        :name => "Name"
      )
    ])
  end

  it "renders a list of admin/markets" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
