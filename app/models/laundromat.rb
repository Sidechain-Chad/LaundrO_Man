class Laundromat < ApplicationRecord
  belongs_to :user

  has_many :orders, dependent: :destroy
  has_many :reviews, dependent: :destroy
  include PgSearch::Model
  pg_search_scope :search_by_name_and_address,
    against: [ :name, :address ],
    using: {
      tsearch: { prefix: true } 
    }
end
