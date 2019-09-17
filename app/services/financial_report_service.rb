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
    get_cashflow_data(cashflow_doc) # 純利益 &　営業キャッシュフローの取得
    get_financial_data(financial_doc) # 売上高 の取得

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

    # Financial reportの作成
    report_q_one = @company.financial_reports.new
    report_q_two = @company.financial_reports.new
    report_q_three = @company.financial_reports.new
    report_q_four = @company.financial_reports.new

    reg_exp_cash_flow = '//div[@id="render-target-default"]//div[@data-reactid="1"]//div[@data-reactid="25"]//span'

    doc.xpath(reg_exp_cash_flow).each do |node|
      # TODO: Alertのとこ、めっちゃでるからロジック必要。

      # 決算の日付の取得
      report_date_title = "#{node.text}" if node.to_s.match(/.*?data-reactid=\"#{reg_exp_period_ending_title}\"/)
      # puts "Alart!!!!!" if report_date_title.present? & report_date_title != "Period Ending"
      report_date_q1 = "#{node.text}" if node.to_s.match(/.*?data-reactid=\"#{reg_exp_period_ending_pq_one}\"/)
      report_date_q2 = "#{node.text}" if node.to_s.match(/.*?data-reactid=\"#{reg_exp_period_ending_pq_two}\"/)
      report_date_q3 = "#{node.text}" if node.to_s.match(/.*?data-reactid=\"#{reg_exp_period_ending_pq_three}\"/)
      report_date_q4 = "#{node.text}" if node.to_s.match(/.*?data-reactid=\"#{reg_exp_period_ending_pq_four}\"/)

      report_q_one.to_date(report_date_q1) unless report_date_q1.blank?
      report_q_two.to_date(report_date_q2) unless report_date_q2.blank?
      report_q_three.to_date(report_date_q3) unless report_date_q3.blank?
      report_q_four.to_date(report_date_q4) unless report_date_q4.blank?

      # 純利益の取得
      net_income_title = "#{node.text}" if node.to_s.match(/.*?data-reactid=\"#{reg_exp_net_income_title}\"/)
      report_q_one.net_income = "#{node.text}".gsub(/,/, '').to_i*1000 if node.to_s.match(/.*?data-reactid=\"#{reg_exp_net_income_pq_one}\"/)
      report_q_two.net_income = "#{node.text}".gsub(/,/, '').to_i*1000 if node.to_s.match(/.*?data-reactid=\"#{reg_exp_net_income_pq_two}\"/)
      report_q_three.net_income = "#{node.text}".gsub(/,/, '').to_i*1000 if node.to_s.match(/.*?data-reactid=\"#{reg_exp_net_income_pq_three}\"/)
      report_q_four.net_income = "#{node.text}".gsub(/,/, '').to_i*1000 if node.to_s.match(/.*?data-reactid=\"#{reg_exp_net_income_pq_four}\"/)
      # puts "Alert!!!" if net_income_title.present? & net_income_title != "Net Income"

      # 営業キャッシュフローの取得
      tcfo_title = "#{node.text}" if node.to_s.match(/.*?data-reactid=\"#{reg_exp_tcfo_pq_title}\"/)
      report_q_one.tcfo = "#{node.text}".gsub(/,/, '').to_i*1000 if node.to_s.match(/.*?data-reactid=\"#{reg_exp_tcfo_pq_one}\"/)
      report_q_two.tcfo = "#{node.text}".gsub(/,/, '').to_i*1000 if node.to_s.match(/.*?data-reactid=\"#{reg_exp_tcfo_pq_two}\"/)
      report_q_three.tcfo = "#{node.text}".gsub(/,/, '').to_i*1000 if node.to_s.match(/.*?data-reactid=\"#{reg_exp_tcfo_pq_three}\"/)
      report_q_four.tcfo = "#{node.text}".gsub(/,/, '').to_i*1000 if node.to_s.match(/.*?data-reactid=\"#{reg_exp_tcfo_pq_four}\"/)
      # puts "Alart!!!!!" if tcfo_title.present? & tcfo_title == "Total Cash Flow From Operating Activities" # TODO
    end

    # save
    report_q_one.save!
    report_q_two.save!
    report_q_three.save!
    report_q_four.save!

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

    # Financial reportの作成
    report_q_one = @company.financial_reports.new
    report_q_two = @company.financial_reports.new
    report_q_three = @company.financial_reports.new
    report_q_four = @company.financial_reports.new

    reg_exp_financial = '//div[@id="render-target-default"]//div[@data-reactid="1"]//div[@data-reactid="25"]//span'

    doc.xpath(reg_exp_financial).each do |node|
      # 日時の取得&保存
      revenue_period_title = "#{node.text}" if node.to_s.match(/.*?data-reactid=\"#{reg_exp_revenue_period_ending_title}\"/)
      revenue_report_date_q1 = "#{node.text}" if node.to_s.match(/.*?data-reactid=\"#{reg_exp_revenue_period_ending_pq_one}\"/)
      revenue_report_date_q2 = "#{node.text}" if node.to_s.match(/.*?data-reactid=\"#{reg_exp_revenue_period_ending_pq_two}\"/)
      revenue_report_date_q3 = "#{node.text}" if node.to_s.match(/.*?data-reactid=\"#{reg_exp_revenue_period_ending_pq_three}\"/)
      revenue_report_date_q4 = "#{node.text}" if node.to_s.match(/.*?data-reactid=\"#{reg_exp_revenue_period_ending_pq_four}\"/)
      report_q_one.to_date(revenue_report_date_q1) unless revenue_report_date_q1.blank?
      report_q_two.to_date(revenue_report_date_q2) unless revenue_report_date_q2.blank?
      report_q_three.to_date(revenue_report_date_q3) unless revenue_report_date_q3.blank?
      report_q_four.to_date(revenue_report_date_q4) unless revenue_report_date_q4.blank?

      # Revenueの取得&保存
      revenue_title = "#{node.text}" if node.to_s.match(/.*?data-reactid=\"#{reg_exp_revenue_title}\"/)
      report_q_one.total_revenue = "#{node.text}".gsub(/,/, '').to_i*1000 if node.to_s.match(/.*?data-reactid=\"#{reg_exp_revenue_pq_one}\"/)
      report_q_two.total_revenue = "#{node.text}".gsub(/,/, '').to_i*1000 if node.to_s.match(/.*?data-reactid=\"#{reg_exp_revenue_pq_two}\"/)
      report_q_three.total_revenue = "#{node.text}".gsub(/,/, '').to_i*1000 if node.to_s.match(/.*?data-reactid=\"#{reg_exp_revenue_pq_three}\"/)
      report_q_four.total_revenue = "#{node.text}".gsub(/,/, '').to_i*1000 if node.to_s.match(/.*?data-reactid=\"#{reg_exp_revenue_pq_four}\"/)
    end

    # save : TODO : 保存が重複するので「今までにない日付があったら取得する」を条件として追加したい
    report_q_one.save!
    report_q_two.save!
    report_q_three.save!
    report_q_four.save!
  end

end