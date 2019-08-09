require "rails_helper"

RSpec.describe Admin::MarketsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/admin/markets").to route_to("admin/markets#index")
    end

    it "routes to #new" do
      expect(:get => "/admin/markets/new").to route_to("admin/markets#new")
    end

    it "routes to #show" do
      expect(:get => "/admin/markets/1").to route_to("admin/markets#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/admin/markets/1/edit").to route_to("admin/markets#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/admin/markets").to route_to("admin/markets#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/admin/markets/1").to route_to("admin/markets#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/admin/markets/1").to route_to("admin/markets#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/admin/markets/1").to route_to("admin/markets#destroy", :id => "1")
    end
  end
end
