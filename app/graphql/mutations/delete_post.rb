module Mutations
  class DeletePost < Mutations::BaseMutation
    argument :id, ID, required: true

    field :message, String, null: false

    def resolve(**args)
      post = Post.find(args[:id])

      policy = PostPolicy.new(current_user, post)
      raise Exceptions::ValidationError, 'You are not authorized to perform this action' unless policy.destroy?

      raise Exceptions::ValidationError, post.errors.full_messages unless post.destroy

      { message: 'Post deleted' }
    end
  end
end
