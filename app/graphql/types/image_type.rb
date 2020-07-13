module Types
  class ImageType < Types::BaseObject
    field :id, ID, null: false
    field :image, String, null: false
  end
end
