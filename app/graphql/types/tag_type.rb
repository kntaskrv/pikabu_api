module Types
  class TagType < Types::BaseObject
    field :id, ID, null: false
    field :tag, String, null: false
  end
end
