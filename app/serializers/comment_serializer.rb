class CommentSerializer < ActiveModel::Serializer
  attributes :id, :commentable_id, :user_id,
             :text, :like_count, :dislike_count,
             :comments

  has_many :images

  def comments
    object.comments.map do |comment|
      CommentSerializer.new(comment).attributes
    end
  end

  def like_count
    object.rates.count(&:like?)
  end

  def dislike_count
    object.rates.count(&:dislike?)
  end
end
