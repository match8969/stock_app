require 'rails_helper'

RSpec.describe "industries/new", type: :view do
  before(:each) do
    assign(:industry, Industry.new(
      :name => "MyString"
    ))
  end

  it "renders new industry form" do
    render

    assert_select "form[action=?][method=?]", industries_path, "post" do

      assert_select "input[name=?]", "industry[name]"
    end
  end
end
