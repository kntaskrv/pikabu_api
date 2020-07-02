class User < ApplicationRecord
  validates :name, presence: true

  has_many :posts
  has_many :comments
  has_many :rates
end
