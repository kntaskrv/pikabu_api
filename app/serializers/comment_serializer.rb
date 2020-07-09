class CommentSerializer < ActiveModel::Serializer
  attributes :id,
             :commentable_id,
             :user_id,
             :text,
             :like_count,
             :dislike_count

  has_many :comments
  has_many :images

  def like_count
    object.rates.count(&:like?)
  end

  def dislike_count
    object.rates.count(&:dislike?)
  end
end
