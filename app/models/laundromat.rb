class Laundromat < ApplicationRecord
  belongs_to :user

  has_many :orders, dependent: :destroy
  has_many :reviews, dependent: :destroy
<<<<<<< HEAD
=======
  has_many_attached :photos
  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?
>>>>>>> 7d0b4326b40516846af396f1bcddf456edf185d3
  include PgSearch::Model
  pg_search_scope :search_by_name_and_address,
    against: [ :name, :address ],
    using: {
<<<<<<< HEAD
      tsearch: { prefix: true } 
=======
      tsearch: { prefix: true }
>>>>>>> 7d0b4326b40516846af396f1bcddf456edf185d3
    }
end
