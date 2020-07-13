module Mutations
  class CreatePost < Mutations::BaseMutation
    argument :user_id, ID, required: true
    argument :title, String, required: false
    argument :description, String, required: false
    argument :tags, [Inputs::TagInput], required: false
    argument :images, [Inputs::ImageInput], required: false

    type Types::PostType

    def resolve(**args)
      raise Exceptions::ValidationError, 'Your rating is too bad' if current_user.bad_rating?

      post = Post.new(
        user_id: args[:user_id],
        title: args[:title],
        description: args[:description]
      )
      post.tags = Tag.where(tag: args[:tags].map(&:tag)) if args[:tags]
      post.images.new(args[:images].map(&:to_h)) if args[:images]

      raise Exceptions::ValidationError, post.errors.full_messages unless post.save

      post
    end
  end
end
