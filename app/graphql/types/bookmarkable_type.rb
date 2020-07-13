module Types
  class BookmarkableType < Types::BaseUnion
    description "Objects which may be commented on"
    possible_types Types::PostType, Types::CommentType

    # Optional: if this method is defined, it will override `Schema.resolve_type`
    def self.resolve_type(object, _context)
      if object.is_a?(Post)
        Types::PostType
      else
        Types::CommentType
      end
    end
  end
end
