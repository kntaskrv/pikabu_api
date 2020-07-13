require 'search_object'
require 'search_object/plugin/graphql'

module Resolvers
  class BookmarkResolver
    include SearchObject.module(:graphql)

    POSSIBLE_TYPES = %w[post comment].freeze

    scope { context[:current_user].bookmarks }

    type [Types::BookmarkableType]

    option :type, type: types.String, required: true, with: :apply_type
    option :first, type: types.Int, with: :apply_first
    option :skip, type: types.Int, with: :apply_skip

    def apply_type(scope, value)
      validate_type!

      bookmark_ids = scope.where(markable_type: value.capitalize).map(&:markable_id)
      value.capitalize.constantize.where(id: bookmark_ids)
    end

    def apply_first(scope, value)
      scope.limit(value)
    end

    def apply_skip(scope, value)
      scope.offset(value)
    end

    def validate_type!
      raise Exceptions::ValidationError, "Wrong type" unless type_valid?
    end

    def type_valid?
      POSSIBLE_TYPES.include?(type.downcase)
    end
  end
end
