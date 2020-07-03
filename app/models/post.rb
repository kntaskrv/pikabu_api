class Post < ApplicationRecord
  validates :title, presence: true

  belongs_to :user

  has_many :tags
  has_many :comments
  has_many :images, as: :imageable
  has_many :rates, as: :rateable

  scope :fresh, -> { where('posts.created_at >= ?', now - 1.day) }
  scope :hot, -> { left_joins(:comments).where('comments.created_at >= ?', now - 1.day).group(:id) }
  scope :best, -> { left_joins(:rates).where('rates.created_at >= ?', Post.now - 1.day).where(rates: { status: 'like' }).group(:id) }
  scope :order_by_likes, -> { left_joins(:rates).where(rates: { status: 'like' }).group(:id).order('count(rates.id) desc') }
  scope :order_by_created, -> { order(created_at: :desc) }
end
