module Mutations
  class DeleteTag < Mutations::BaseMutation
    argument :id, ID, required: true

    field :message, String, null: false

    def resolve(**args)
      tag = Tag.find(args[:id])

      policy = TagPolicy.new(current_user, tag)
      raise Exceptions::AccessDenied, 'You are not authorized to perform this action' unless policy.destroy?

      raise Exceptions::ValidationError, tag.errors.full_messages unless tag.destroy

      Sunspot.index! tag.posts

      { message: 'Tag deleted' }
    end
  end
end
