class CommentSerializer < ActiveModel::Serializer
  attributes :id, :post_id, :user_id, :text

  has_many :images
end
