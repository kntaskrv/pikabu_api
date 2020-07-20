class Comment < ApplicationRecord
  acts_as_paranoid

  validates :text, presence: true

  belongs_to :user
  belongs_to :commentable, polymorphic: true

  has_many :comments, as: :commentable, dependent: :destroy
  has_many :images, as: :imageable, dependent: :destroy
  has_many :rates, as: :rateable, dependent: :destroy
  has_many :bookmarks, as: :markable, dependent: :destroy

  scope :order_by_likes, -> { left_joins(:rates).where(rates: { status: 'like' }).group(:id).order('count(rates.id) desc') }
  scope :order_by_created, -> { order(created_at: :desc) }
  scope :fresh, -> { where('comments.created_at >= ?', now - 1.day) }

  searchable do
    integer :user_id
    integer :commentable_id
    string :commentable_type
    time :created_at
    integer :rating
  end

  def rating
    rates.count(&:like?) - rates.count(&:dislike?)
  end
end
