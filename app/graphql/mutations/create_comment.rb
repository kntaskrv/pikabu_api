module Mutations
  class CreateComment < Mutations::BaseMutation
    argument :commentable_id, ID, required: true
    argument :commentable_type, String, required: true
    argument :text, String, required: true
    argument :images, [Inputs::ImageInput], required: false

    type Types::CommentType

    attr_reader :args

    def resolve(**args)
      @args = args
      argument_validate!

      comment = commentable.comments.new(
        user: current_user,
        text: args[:text]
      )
      comment.images.new(args[:images].map(&:to_h)) if args[:images]

      raise Exceptions::ValidationError, comment.errors.full_messages unless comment.save

      Sunspot.index! commentable

      comment
    end

    private

    def argument_validate!
      raise Exceptions::ValidationError, "Wrong type" unless type_valid?
    end

    def type_valid?
      %w[post comment].include?(args[:commentable_type]&.downcase)
    end

    def commentable
      @commentable || args[:commentable_type]&.capitalize&.constantize&.find(args[:commentable_id])
    end
  end
end
