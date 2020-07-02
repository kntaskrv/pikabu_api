class Comment < ApplicationRecord
  validates :text, presence: true

  belongs_to :user
  belongs_to :post

  has_many :images, as: :imageable
  has_many :rates, as: :rateable
end
