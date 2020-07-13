module Mutations
  class CreateUser < Mutations::BaseMutation
    argument :name, String, required: true
    argument :rate, Integer, required: false
    argument :admin, Boolean, required: false

    type Types::UserType

    def resolve(name: nil, rate: 0, admin: false)
      user = User.new(name: name, rate: rate, admin: admin)

      raise Exceptions::ValidationError, user.errors.full_messages unless user.save

      user
    end
  end
end
