class PostSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :title, :like_count, :dislike_count

  has_many :images
  has_many :tags
  has_many :comments

  def like_count
    object.rates.count(&:like?)
  end

  def dislike_count
    object.rates.count(&:dislike?)
  end
end
