module Mutations
  class DeleteUser < Mutations::BaseMutation
    argument :id, ID, required: true

    field :message, String, null: false

    def resolve(**args)
      user = User.find(args[:id])

      policy = UserPolicy.new(current_user, user)
      raise Exceptions::AccessDenied, 'You are not authorized to perform this action' unless policy.destroy?

      raise Exceptions::ValidationError, user.errors.full_messages unless user.destroy

      { message: 'User deleted' }
    end
  end
end
