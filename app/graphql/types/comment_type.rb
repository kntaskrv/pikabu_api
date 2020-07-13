module Types
  class CommentType < Types::BaseObject
    field :id, ID, null: false
    field :text, String, null: false
    field :images, [Types::ImageType], null: false
    field :comments, [Types::CommentType], null: false
  end
end
