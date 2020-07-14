module Mutations
  class CreateTag < Mutations::BaseMutation
    argument :tag, String, required: true

    type Types::TagType

    def resolve(tag = nil)
      tag = Tag.new(tag)

      policy = TagPolicy.new(current_user, tag)

      raise Exceptions::AccessDenied, 'You are not authorized to perform this action' unless policy.create?
      raise Exceptions::ValidationError, tag.errors.full_messages unless tag.save

      tag
    end
  end
end
