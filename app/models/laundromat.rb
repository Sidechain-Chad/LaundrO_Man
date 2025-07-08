class Laundromat < ApplicationRecord
  # belongs_to :owner

  has_many :orders, dependent: :destroy
  has_many :reviews, dependent: :destroy
end
