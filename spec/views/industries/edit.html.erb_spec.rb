require 'rails_helper'

RSpec.describe "industries/edit", type: :view do
  before(:each) do
    @industry = assign(:industry, Industry.create!(
      :name => "MyString"
    ))
  end

  it "renders the edit industry form" do
    render

    assert_select "form[action=?][method=?]", industry_path(@industry), "post" do

      assert_select "input[name=?]", "industry[name]"
    end
  end
end
