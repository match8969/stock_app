class Company < ApplicationRecord
  has_many :favorites, dependent: :destroy
end
