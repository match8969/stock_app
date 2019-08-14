class Company < ApplicationRecord
  has_many :favorites, dependent: :destroy
  has_many :holdings, dependent: :destroy
  has_one :stock, dependent: :destroy
  belongs_to :country
end
