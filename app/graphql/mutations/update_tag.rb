module Mutations
  class UpdateTag < Mutations::BaseMutation
    argument :id, ID, required: true
    argument :tag, String, required: true

    type Types::TagType

    def resolve(**args)
      tag = Tag.find(args[:id])

      policy = TagPolicy.new(current_user, tag)
      raise Exceptions::AccessDenied, 'You are not authorized to perform this action' unless policy.update?

      tag.tag = args[:tag]
      raise Exceptions::ValidationError, tag.errors.full_messages unless tag.save

      Sunspot.index! tag.posts

      tag
    end
  end
end
