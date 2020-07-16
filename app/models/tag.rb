class Tag < ApplicationRecord
  validates :tag, presence: true

  has_many :tagging
  has_many :posts, through: :tagging

  searchable do
    text :tag
  end
end
