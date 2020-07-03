class Comment < ApplicationRecord
  validates :text, presence: true

  belongs_to :user
  belongs_to :post

  has_many :images, as: :imageable
  has_many :rates, as: :rateable

  scope :order_by_likes, -> { left_joins(:rates).where(rates: { status: 'like' }).group(:id).order('count(rates.id) desc') }
  scope :order_by_created, -> { order(created_at: :desc) }
end
