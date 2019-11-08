class FinancialReportService
  # attr_reader :company_id # TODO: 検討中

  def initialize(company_id)
    @company = Company.find(company_id)
  end

  def scraping_yahoo_finance
    require 'open-uri'
    require 'nokogiri'
    require 'uri'

    stock = @company.stock
    ticker_symbol = stock.code

    # スクレイピング先のURL
    root_yahoo_finance_url = 'https://finance.yahoo.com/'
    cashflow_url = "#{root_yahoo_finance_url}/quote/#{ticker_symbol}/cash-flow?p=#{ticker_symbol}"
    financial_url = "#{root_yahoo_finance_url}/quote/#{ticker_symbol}/financials?p=#{ticker_symbol}"

    # 営業キャッシュフロー & 純利益
    charset = nil
    cashflow_html = open(cashflow_url) do |f|
      charset = f.charset # 文字種別を取得
      f.read # htmlを読み込んで変数htmlに渡す
    end
    # htmlをパース(解析)してオブジェクトを生成
    cashflow_doc = Nokogiri::HTML.parse(cashflow_html, nil, charset)

    # タイトルを表示
    puts "cash_flow : #{cashflow_doc.title}" # OK : "Roku, Inc. (ROKU) Cash Flow"

    # 売上高
    charset = nil
    financial_html = open(financial_url) do |f|
      charset = f.charset # 文字種別を取得
      f.read # htmlを読み込んで変数htmlに渡す
    end
    # htmlをパース(解析)してオブジェクトを生成
    financial_doc = Nokogiri::HTML.parse(financial_html, nil, charset)

    # タイトルを表示
    puts "Financial : #{financial_doc.title}" # OK : Roku, Inc. (ROKU) Income Statement

    # 解析
    report_qs_cashflows = get_cashflow_data(cashflow_doc) # 純利益 &　営業キャッシュフローの取得
    report_qs_financials = get_financial_data(financial_doc) # 売上高 の取得

    # TODO: ロジックきたない。
    report_qs_cashflows.each do |rqc|
      report_qs_financials.each do |rqf|
        rqc[:total_revenue] = rqf[:total_revenue] if rqc[:report_date] == rqf[:report_date]
      end
    end

    report_qs_cashflows.each do |rqc|
      next if @company.financial_reports.where(report_date: rqc[:report_date]).present?
      new_report = @company.financial_reports.new(report_date: rqc[:report_date],
                                                    tcfo: rqc[:tcfo],
                                                    net_income: rqc[:net_income],
                                                    total_revenue: rqc[:total_revenue])
      new_report.save!
    end

  end

  # helper
  def to_date(report_date)
    return unless report_date.match(/\d*\/\d*\/\d*/) # 日付でないのは処理しない
    date_array = report_date.split('/')
    report_date = DateTime.new(date_array[2].to_i, date_array[0].to_i, date_array[1].to_i)
  end

  private

  # Total Cash Flow From Operating Activities : 営業キャッシュフロー
  # Net Income : 純利益
  def get_cashflow_data(doc)
    # Enum
    ## period
    reg_exp_period_ending_title = 30
    reg_exp_period_ending_pq_one = 32
    reg_exp_period_ending_pq_two = 34
    reg_exp_period_ending_pq_three = 36
    reg_exp_period_ending_pq_four = 38

    ## net_income
    reg_exp_net_income_title = 41
    reg_exp_net_income_pq_one = 43
    reg_exp_net_income_pq_two = 45
    reg_exp_net_income_pq_three = 47
    reg_exp_net_income_pq_four = 49
    ## 営業キャッシュフロー
    reg_exp_tcfo_pq_title = 121
    reg_exp_tcfo_pq_one = 123
    reg_exp_tcfo_pq_two = 125
    reg_exp_tcfo_pq_three = 127
    reg_exp_tcfo_pq_four = 129

    # 保存用ハッシュ
    report_q_one = {}
    report_q_two = {}
    report_q_three = {}
    report_q_four = {}

    reg_exp_cash_flow = '//div[@id="render-target-default"]//div[@data-reactid="1"]//div[@data-reactid="25"]//span'

    doc.xpath(reg_exp_cash_flow).each do |node|
      # TODO: Alertのとこ、めっちゃでるからロジック必要。

      # 決算の日付の取得
      report_date_title = "#{node.text}" if node.to_s.match(/.*?data-reactid=\"#{reg_exp_period_ending_title}\"/)

      report_date_q1 = "#{node.text}" if node.to_s.match(/.*?data-reactid=\"#{reg_exp_period_ending_pq_one}\"/)
      report_date_q2 = "#{node.text}" if node.to_s.match(/.*?data-reactid=\"#{reg_exp_period_ending_pq_two}\"/)
      report_date_q3 = "#{node.text}" if node.to_s.match(/.*?data-reactid=\"#{reg_exp_period_ending_pq_three}\"/)
      report_date_q4 = "#{node.text}" if node.to_s.match(/.*?data-reactid=\"#{reg_exp_period_ending_pq_four}\"/)

      report_q_one[:report_date] = self.to_date(report_date_q1) unless report_date_q1.blank?
      report_q_two[:report_date] = self.to_date(report_date_q2) unless report_date_q2.blank?
      report_q_three[:report_date] = self.to_date(report_date_q3) unless report_date_q3.blank?
      report_q_four[:report_date] = self.to_date(report_date_q4) unless report_date_q4.blank?

      # 純利益の取得
      net_income_title = "#{node.text}" if node.to_s.match(/.*?data-reactid=\"#{reg_exp_net_income_title}\"/)
      report_q_one[:net_income] = "#{node.text}".gsub(/,/, '').to_i*1000 if node.to_s.match(/.*?data-reactid=\"#{reg_exp_net_income_pq_one}\"/)
      report_q_two[:net_income] = "#{node.text}".gsub(/,/, '').to_i*1000 if node.to_s.match(/.*?data-reactid=\"#{reg_exp_net_income_pq_two}\"/)
      report_q_three[:net_income] = "#{node.text}".gsub(/,/, '').to_i*1000 if node.to_s.match(/.*?data-reactid=\"#{reg_exp_net_income_pq_three}\"/)
      report_q_four[:net_income] = "#{node.text}".gsub(/,/, '').to_i*1000 if node.to_s.match(/.*?data-reactid=\"#{reg_exp_net_income_pq_four}\"/)

      # puts "Alert!!!" if net_income_title.present? & net_income_title != "Net Income"

      # 営業キャッシュフローの取得
      tcfo_title = "#{node.text}" if node.to_s.match(/.*?data-reactid=\"#{reg_exp_tcfo_pq_title}\"/)
      report_q_one[:tcfo] = "#{node.text}".gsub(/,/, '').to_i*1000 if node.to_s.match(/.*?data-reactid=\"#{reg_exp_tcfo_pq_one}\"/)
      report_q_two[:tcfo] = "#{node.text}".gsub(/,/, '').to_i*1000 if node.to_s.match(/.*?data-reactid=\"#{reg_exp_tcfo_pq_two}\"/)
      report_q_three[:tcfo] = "#{node.text}".gsub(/,/, '').to_i*1000 if node.to_s.match(/.*?data-reactid=\"#{reg_exp_tcfo_pq_three}\"/)
      report_q_four[:tcfo] = "#{node.text}".gsub(/,/, '').to_i*1000 if node.to_s.match(/.*?data-reactid=\"#{reg_exp_tcfo_pq_four}\"/)
      # puts "Alart!!!!!" if tcfo_title.present? & tcfo_title == "Total Cash Flow From Operating Activities" # TODO
    end
    report_qs = [report_q_one, report_q_two, report_q_three, report_q_four]
  end

  # Total Revenue : 売上高
  def get_financial_data(doc)
    puts "----- [get_financial_data] start -----"
    # period
    reg_exp_revenue_period_ending_title = 30
    reg_exp_revenue_period_ending_pq_one = 32
    reg_exp_revenue_period_ending_pq_two = 34
    reg_exp_revenue_period_ending_pq_three = 36
    reg_exp_revenue_period_ending_pq_four = 38

    # revenue
    reg_exp_revenue_title = 41
    reg_exp_revenue_pq_one = 43
    reg_exp_revenue_pq_two = 45
    reg_exp_revenue_pq_three = 47
    reg_exp_revenue_pq_four = 49

    # 保存用ハッシュ
    report_q_one = {}
    report_q_two = {}
    report_q_three = {}
    report_q_four = {}

    reg_exp_financial = '//div[@id="render-target-default"]//div[@data-reactid="1"]//div[@data-reactid="25"]//span'

    doc.xpath(reg_exp_financial).each do |node|
      # 日時の取得&保存
      revenue_period_title = "#{node.text}" if node.to_s.match(/.*?data-reactid=\"#{reg_exp_revenue_period_ending_title}\"/)
      revenue_report_date_q1 = "#{node.text}" if node.to_s.match(/.*?data-reactid=\"#{reg_exp_revenue_period_ending_pq_one}\"/)
      revenue_report_date_q2 = "#{node.text}" if node.to_s.match(/.*?data-reactid=\"#{reg_exp_revenue_period_ending_pq_two}\"/)
      revenue_report_date_q3 = "#{node.text}" if node.to_s.match(/.*?data-reactid=\"#{reg_exp_revenue_period_ending_pq_three}\"/)
      revenue_report_date_q4 = "#{node.text}" if node.to_s.match(/.*?data-reactid=\"#{reg_exp_revenue_period_ending_pq_four}\"/)
      report_q_one[:report_date] = self.to_date(revenue_report_date_q1) unless revenue_report_date_q1.blank?
      report_q_two[:report_date] = self.to_date(revenue_report_date_q2) unless revenue_report_date_q2.blank?
      report_q_three[:report_date] = self.to_date(revenue_report_date_q3) unless revenue_report_date_q3.blank?
      report_q_four[:report_date] = self.to_date(revenue_report_date_q4) unless revenue_report_date_q4.blank?

      # Revenueの取得&保存
      revenue_title = "#{node.text}" if node.to_s.match(/.*?data-reactid=\"#{reg_exp_revenue_title}\"/)
      report_q_one[:total_revenue] = "#{node.text}".gsub(/,/, '').to_i*1000 if node.to_s.match(/.*?data-reactid=\"#{reg_exp_revenue_pq_one}\"/)
      report_q_two[:total_revenue] = "#{node.text}".gsub(/,/, '').to_i*1000 if node.to_s.match(/.*?data-reactid=\"#{reg_exp_revenue_pq_two}\"/)
      report_q_three[:total_revenue] = "#{node.text}".gsub(/,/, '').to_i*1000 if node.to_s.match(/.*?data-reactid=\"#{reg_exp_revenue_pq_three}\"/)
      report_q_four[:total_revenue] = "#{node.text}".gsub(/,/, '').to_i*1000 if node.to_s.match(/.*?data-reactid=\"#{reg_exp_revenue_pq_four}\"/)
    end
    report_qs = [report_q_one, report_q_two, report_q_three, report_q_four]
  end



end