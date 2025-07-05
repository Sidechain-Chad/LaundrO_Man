class Laundromat < ApplicationRecord
  # belongs_to :owner

  has_many :orders, dependent: :destroy
end
