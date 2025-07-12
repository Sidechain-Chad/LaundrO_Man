class Order < ApplicationRecord
  belongs_to :user
  belongs_to :laundromat
  has_many :messages, dependent: :destroy
  has_many :order_items, dependent: :destroy
  has_many :order_trackings, dependent: :destroy
end
