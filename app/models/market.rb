class Market < ApplicationRecord
  has_one :stock, dependent: :destroy
end
