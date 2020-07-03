class Bookmark < ApplicationRecord
  validates :user_id, uniqueness: { scope: %i[markable_id markable_type] }

  belongs_to :markable, polymorphic: true
  belongs_to :user
end
