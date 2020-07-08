class User < ApplicationRecord
  acts_as_paranoid

  validates :name, presence: true

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :rates, dependent: :destroy
  has_many :bookmarks, dependent: :destroy

  def bad_rating?
    rate < -10
  end
end
