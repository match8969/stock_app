class Admin::MarketsController < ApplicationController
  before_action :set_market, only: [:show, :edit, :update, :destroy]

  # GET /admin/markets
  # GET /admin/markets.json
  def index
    @markets = Admin::Market.all
  end

  # GET /admin/markets/1
  # GET /admin/markets/1.json
  def show
  end

  # GET /admin/markets/new
  def new
    @market = Market.new
  end

  # GET /admin/markets/1/edit
  def edit
  end

  # POST /admin/markets
  # POST /admin/markets.json
  def create
    @market = Market.new(market_params)

    respond_to do |format|
      if @market.save
        format.html { redirect_to [:admin, @market], notice: 'Market was successfully created.' }
        format.json { render :show, status: :created, location: [:admin, @market]}
      else
        format.html { render :new }
        format.json { render json: @market.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/markets/1
  # PATCH/PUT /admin/markets/1.json
  def update
    respond_to do |format|
      if @market.update(market_params)
        format.html { redirect_to [:admin, @market], notice: 'Market was successfully updated.' }
        format.json { render :show, status: :ok, location: @market }
      else
        format.html { render :edit }
        format.json { render json: @market.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/markets/1
  # DELETE /admin/markets/1.json
  def destroy
    @market.destroy
    respond_to do |format|
      format.html { redirect_to admin_markets_url, notice: 'Market was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_market
      @market = Market.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def market_params
      params.require(:market).permit(:name)
    end
end
