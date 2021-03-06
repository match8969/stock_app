class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable

  has_many :favorites, dependent: :destroy
  has_many :fav_companies, through: :favorites, source: :company

  has_many :holdings, dependent: :destroy
  has_many :holding_companies, through: :holdings, source: :company

  def already_faved_company?(company)
    self.fav_companies.exists?(id: company.id)
  end

  def already_holding_company?(company)
    self.holding_companies.exists?(id: company.id)
  end


  def is_admin?
    self.can == 777 # TODO : to enums
  end

end
