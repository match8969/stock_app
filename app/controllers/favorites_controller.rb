class FavoritesController < ApplicationController
  def create
    like = current_user.favorites.create(company_id: params[:company_id])
    redirect_back(fallback_location: root_path)
  end

  def destroy
    favorite = Favorite.find_by(company_id: params[:company_id], user_id: current_user.id)
    favorite.destroy
    redirect_back(fallback_location: root_path)
  end
end
