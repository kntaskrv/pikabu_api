class Rate < ApplicationRecord
  validates :user_id, uniqueness: { scope: %i[rateable_id rateable_type] }

  belongs_to :rateable, polymorphic: true
  belongs_to :user

  enum status: { like: 0, dislike: 1 }
end
