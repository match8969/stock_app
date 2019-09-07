class FinancialReport < ApplicationRecord
  belongs_to :company

    def to_date(report_date)
      return unless report_date.match(/\d*\/\d*\/\d*/) # 日付でないのは処理しない
      date_array = report_date.split('/')
      self.report_date = DateTime.new(date_array[2].to_i, date_array[0].to_i, date_array[1].to_i)
    end
end
