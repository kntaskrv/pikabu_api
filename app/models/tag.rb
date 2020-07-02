class Tag < ApplicationRecord
  validates :tag, presence: true

  belongs_to :post
end
