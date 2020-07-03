class Post < ApplicationRecord
  acts_as_paranoid

  validates :title, presence: true

  belongs_to :user

  has_many :tags, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :images, as: :imageable, dependent: :destroy
  has_many :rates, as: :rateable, dependent: :destroy
  has_many :bookmarks, as: :markable, dependent: :destroy

  scope :fresh, -> { where('posts.created_at >= ?', now - 1.day) }
  scope :hot, -> { left_joins(:comments).where('comments.created_at >= ?', now - 1.day).group(:id) }
  scope :best, -> { left_joins(:rates).where('rates.created_at >= ?', Post.now - 1.day).where(rates: { status: 'like' }).group(:id) }
  scope :order_by_likes, -> { left_joins(:rates).where(rates: { status: 'like' }).group(:id).order('count(rates.id) desc') }
  scope :order_by_created, -> { order(created_at: :desc) }
end
