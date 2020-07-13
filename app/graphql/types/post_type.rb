module Types
  class PostType < Types::BaseObject
    field :id, ID, null: false
    field :title, String, null: false
    field :comments, [Types::CommentType], null: false
    field :images, [Types::ImageType], null: false
    field :tags, [Types::TagType], null: false
    field :rate, Integer, null: true
    field :likes_count, Integer, null: true
    field :dislikes_count, Integer, null: true

    def rate
      object.rating
    end

    def likes_count
      object.rates.count(&:like?)
    end

    def dislikes_count
      object.rates.count(&:dislike?)
    end
  end
end
