class CommentSerializer < ActiveModel::Serializer
  attributes :id, :commentable_id, :user_id, :text

  has_many :images
end
