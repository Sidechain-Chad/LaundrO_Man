class Review < ApplicationRecord
  belongs_to :user
  belongs_to :laundromat
  validates :content, presence: true
end
