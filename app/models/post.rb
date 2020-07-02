class Post < ApplicationRecord
  validates :title, presence: true

  belongs_to :user

  has_many :tags
  has_many :images, as: :imageable
  has_many :rates, as: :rateable
end
