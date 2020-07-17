module Mutations
  class CreateBookmark < Mutations::BaseMutation
    argument :markable_id, ID, required: true
    argument :markable_type, String, required: true

    field :message, String, null: false

    attr_reader :args

    def resolve(**args)
      @args = args
      argument_validate!

      mark = current_user.bookmarks.new(markable: markable)
      raise Exceptions::ValidationError, mark.errors.full_messages unless mark.save

      Sunspot.index! markable

      { message: 'Bookmark created' }
    end

    private

    def argument_validate!
      raise Exceptions::ValidationError, "Wrong type" unless type_valid?
    end

    def type_valid?
      %w[post comment].include?(args[:markable_type]&.downcase)
    end

    def markable
      @markable || args[:markable_type]&.capitalize&.constantize&.find(args[:markable_id])
    end
  end
end
