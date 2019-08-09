class Company < ApplicationRecord
  has_many :favorites, dependent: :destroy
  has_many :holdings, dependent: :destroy
end
