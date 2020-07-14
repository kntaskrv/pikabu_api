module Mutations
  class DeleteComment < Mutations::BaseMutation
    argument :id, ID, required: true

    field :message, String, null: false

    def resolve(**args)
      comment = Comment.find(args[:id])

      policy = CommentPolicy.new(current_user, comment)
      raise Exceptions::AccessDenied, 'You are not authorized to perform this action' unless policy.destroy?

      raise Exceptions::ValidationError, comment.errors.full_messages unless comment.destroy

      { message: 'Comment deleted' }
    end
  end
end
