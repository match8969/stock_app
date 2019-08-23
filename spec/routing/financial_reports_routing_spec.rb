require "rails_helper"

RSpec.describe FinancialReportsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/financial_reports").to route_to("financial_reports#index")
    end

    it "routes to #new" do
      expect(:get => "/financial_reports/new").to route_to("financial_reports#new")
    end

    it "routes to #show" do
      expect(:get => "/financial_reports/1").to route_to("financial_reports#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/financial_reports/1/edit").to route_to("financial_reports#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/financial_reports").to route_to("financial_reports#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/financial_reports/1").to route_to("financial_reports#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/financial_reports/1").to route_to("financial_reports#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/financial_reports/1").to route_to("financial_reports#destroy", :id => "1")
    end
  end
end
