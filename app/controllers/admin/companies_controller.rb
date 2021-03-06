class Admin::CompaniesController < ApplicationController
  before_action :set_company, only: [:show, :edit, :update, :destroy, :update_financial_report]

  # GET /companies
  # GET /companies.json
  def index
    @companies = Company.all
  end

  # GET /companies/1
  # GET /companies/1.json
  def show
  end

  # GET /companies/new
  def new
    @company = Company.new
  end

  # GET /companies/1/edit
  def edit
  end

  # POST /companies
  # POST /companies.json
  def create
    ActiveRecord::Base.transaction do
      @company = Company.new(company_params)
      # TODO: more secure
      @company.stock = Stock.new(market_id: params[:company][:market_id],code: params[:company][:code])
      @company.save!
    end

    respond_to do |format|
      if @company.save
        format.html { redirect_to [:admin, @company], notice: 'Company was successfully created.' }
        format.json { render :show, status: :created, location: [:admin, @company] }
      else
        format.html { render :new }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /companies/1
  # PATCH/PUT /companies/1.json
  def update
    respond_to do |format|
      if @company.update(company_params)
        format.html { redirect_to [:admin, @company], notice: 'Company was successfully updated.' }
        format.json { render :show, status: :ok, location: [:admin, @company] }
      else
        format.html { render :edit }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /companies/1
  # DELETE /companies/1.json
  def destroy
    @company.destroy
    respond_to do |format|
      format.html { redirect_to admin_companies_url, notice: 'Company was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  # 決算書の更新
  def update_financial_report
    puts "=== update_financial_report ==="
    FinancialReportService.new(@company.id).scraping_yahoo_finance
    redirect_back(fallback_location: root_path)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_company
      @company = Company.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def company_params
      params.require(:company).permit(:name, :country_id, :industry_id)
    end
end
