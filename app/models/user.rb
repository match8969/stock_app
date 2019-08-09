class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable

  has_many :favorites, dependent: :destroy
  has_many :fav_companies, through: :favorites, source: :company

  def already_faved_company?(company)
    self.fav_companies.exists?(id: company.id)
  end

end
