class PostSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :title

  has_many :images
  has_many :tags
end
