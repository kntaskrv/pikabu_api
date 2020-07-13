module Types
  class UserType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :rate, Integer, null: true
    field :admin, Boolean, null: true
  end
end
