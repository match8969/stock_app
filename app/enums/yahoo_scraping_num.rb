class YahooScapingNum < Inum::Base
  ## CASH FLOW PAGE #
  # Period Ending
  define :PE_TITLE, 30
  define :PE_ONE, 32
  define :PE_TWO, 34
  define :PE_THREE, 36
  define :PE_FOUR, 38

  # 純利益
  define :NET_INCOME_TITLE, 41
  define :NET_INCOME_ONE, 43
  define :NET_INCOME_TWO,45
  define :NET_INCOME_THREE,47
  define :NET_INCOME_FOUR,49

  # 営業キャッシュフロー
  define :REG_EXP_TCFO_TITLE, 121
  define :REG_EXP_TCFO_PQ_ONE, 123
  define :REG_EXP_TCFO_PQ_TWO, 125
  define :REG_EXP_TCFO_PQ_THREE, 127
  define :REG_EXP_TCFO_PQ_FOUR, 129

  ## FINANCIAL PAGE ##
  # Period Ending
  define :REG_EXP_REVENUE_PERIOD_ENDING_TITLE, 30
  define :REG_EXP_REVENUE_PERIOD_ENDING_PQ_ONE, 32
  define :REG_EXP_REVENUE_PERIOD_ENDING_PQ_TWO, 34
  define :REG_EXP_REVENUE_PERIOD_ENDING_PQ_THREE,36
  define :REG_EXP_REVENUE_PERIOD_ENDING_PQ_FOUR, 38

  # 純利益
  define :REG_EXP_REVENUE_TITLE, 41
  define :REG_EXP_REVENUE_PQ_ONE, 43
  define :REG_EXP_REVENUE_PQ_TWO, 45
  define :REG_EXP_REVENUE_PQ_THREE, 47
  define :REG_EXP_REVENUE_PQ_FOUR, 49
end