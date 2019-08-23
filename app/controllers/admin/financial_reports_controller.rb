class Admin::FinancialReportsController < ApplicationController
  before_action :set_financial_report, only: [:show, :edit, :update, :destroy]

  # GET /financial_reports
  # GET /financial_reports.json
  def index
    @financial_reports = FinancialReport.all
  end

  # GET /financial_reports/1
  # GET /financial_reports/1.json
  def show
  end

  # GET /financial_reports/new
  def new
    @financial_report = FinancialReport.new
  end

  # GET /financial_reports/1/edit
  def edit
  end

  # POST /financial_reports
  # POST /financial_reports.json
  def create
    @financial_report = FinancialReport.new(financial_report_params)

    respond_to do |format|
      if @financial_report.save
        format.html { redirect_to [:admin, @financial_report], notice: 'Financial report was successfully created.' }
        format.json { render :show, status: :created, location: [:admin, @financial_report] }
      else
        format.html { render :new }
        format.json { render json: @financial_report.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /financial_reports/1
  # PATCH/PUT /financial_reports/1.json
  def update
    respond_to do |format|
      if @financial_report.update(financial_report_params)
        format.html { redirect_to [:admin, @financial_report], notice: 'Financial report was successfully updated.' }
        format.json { render :show, status: :ok, location: [:admin, @financial_report] }
      else
        format.html { render :edit }
        format.json { render json: @financial_report.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /financial_reports/1
  # DELETE /financial_reports/1.json
  def destroy
    @financial_report.destroy
    respond_to do |format|
      format.html { redirect_to financial_reports_url, notice: 'Financial report was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_financial_report
      @financial_report = FinancialReport.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def financial_report_params
      params.require(:financial_report).permit(:tcfo, :net_income, :total_revenue)
    end
end
