class FinancialReport < ApplicationRecord
  belongs_to :company


    def to_date(report_date)
      # TODO: ここにスクレイピングして取得した日付を
      # datetimeに変更する処理

      # input : 12/31/2018
      # goal : 2018-02-28 00:09:37


      puts "report_date : #{report_date}"

      date_array = report_date.split('/')
      puts "date_array : #{date_array}"

      puts "date_array[2].to_i : #{date_array[2].to_i}" # 2018
      puts "date_array[1].to_i : #{date_array[1].to_i}" # 31
      puts "date_array[0].to_i : #{date_array[0].to_i}" # 12

      dt = DateTime.new(
          date_array[2].to_i,
          date_array[0].to_i,
          date_array[1].to_i)
      puts "dt : #{dt}"
      self.report_date = dt
      puts "self.report_date : #{self.report_date}"
    end
end
