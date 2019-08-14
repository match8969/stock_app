class HoldingsController < ApplicationController
  def create
    holding = current_user.holdings.create(company_id: params[:company_id])
    redirect_back(fallback_location: root_path)
  end

  def destroy
    holding = Holding.find_by(company_id: params[:company_id], user_id: current_user.id)
    holding.destroy
    redirect_back(fallback_location: root_path)
  end
end
