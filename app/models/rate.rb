class Rate < ApplicationRecord
  validates :user_id, uniqueness: { scope: %i[rateable_id rateable_type], message: 'already has this rate' }

  belongs_to :rateable, polymorphic: true
  belongs_to :user

  enum status: { like: 0, dislike: 1 }

  scope :fresh, -> { where('rates.created_at >= ?', now - 1.day) }
end
