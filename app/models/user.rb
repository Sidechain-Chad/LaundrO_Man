class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: { customer: 0, driver: 1, owner: 2, admin: 3 }
  has_many :orders, dependent: :destroy
  has_one :laundromat
end
