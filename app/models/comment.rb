class Comment < ApplicationRecord
  acts_as_paranoid

  validates :text, presence: true

  belongs_to :user
  belongs_to :post

  has_many :images, as: :imageable, dependent: :destroy
  has_many :rates, as: :rateable, dependent: :destroy
  has_many :bookmarks, as: :markable, dependent: :destroy

  scope :order_by_likes, -> { left_joins(:rates).where(rates: { status: 'like' }).group(:id).order('count(rates.id) desc') }
  scope :order_by_created, -> { order(created_at: :desc) }
end
