class Stock < ApplicationRecord
  belongs_to :company
  belongs_to :market

  # state
  enum state: {inactive: 0, active: 1}, _prefix: true
end
