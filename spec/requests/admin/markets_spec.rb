require 'rails_helper'

RSpec.describe "Admin::Markets", type: :request do
  describe "GET /admin/markets" do
    it "works! (now write some real specs)" do
      get admin_markets_path
      expect(response).to have_http_status(200)
    end
  end
end
