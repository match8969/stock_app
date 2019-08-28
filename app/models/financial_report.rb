class FinancialReport < ApplicationRecord
  belongs_to :company

  private
    def to_date(report_date)
      # TODO: ここにスクレイピングして取得した日付を
      # datetimeに変更する処理

    end
end
