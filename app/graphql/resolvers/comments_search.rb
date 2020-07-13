require 'search_object'
require 'search_object/plugin/graphql'

module Resolvers
  class CommentsSearch
    include SearchObject.module(:graphql)

    scope { Comment.all }

    type [Types::CommentType]

    option :filter, type: Inputs::Filters::CommentFilter, with: :apply_filter

    def apply_filter(_scope, value)
      Comments::Load.call(value.to_h)
    end
  end
end
