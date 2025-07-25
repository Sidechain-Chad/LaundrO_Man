class Order < ApplicationRecord
  belongs_to :user
  belongs_to :laundromat

  has_many :order_items, dependent: :destroy
  has_many :order_trackings, dependent: :destroy

  enum status: { unconfirmed: 0, pending: 1, processing: 2, in_transit: 3, delivered: 4, cancelled: 5 }

  accepts_nested_attributes_for :order_items, allow_destroy: true
end
