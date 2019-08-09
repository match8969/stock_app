class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         :confirmable, :lockable, :timeoutable, :omniauthable

  has_many :favorites, dependent: :destroy
end
