class Stock < ApplicationRecord
  belongs_to :company
  belongs_to :market
end
