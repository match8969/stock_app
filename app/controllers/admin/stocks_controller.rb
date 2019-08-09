class Admin::StocksController < ApplicationController
before_action :set_stock, only: [:edit, :update, :destroy]


  def create
    @stock = stock.new(stock_params)

    respond_to do |format|
      if @stock.save
        format.html { redirect_to [:admin, @stock], notice: 'stock was successfully created.' }
        format.json { render :show, status: :created, location: [:admin, @stock]}
      else
        format.html { render :new }
        format.json { render json: @stock.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @stock.update(stock_params)
        format.html { redirect_to [:admin, @stock], notice: 'stock was successfully updated.' }
        format.json { render :show, status: :ok, location: @stock }
      else
        format.html { render :edit }
        format.json { render json: @stock.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @stock.destroy
    respond_to do |format|
      format.html { redirect_to admin_stocks_url, notice: 'stock was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_stock
    @stock = stock.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def stock_params
    params.require(:stock).permit(:name)
  end
end
