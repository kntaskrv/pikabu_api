require 'search_object'
require 'search_object/plugin/graphql'

module Resolvers
  class PostsSearchByTitle
    include SearchObject.module(:graphql)

    scope { Post.all }

    type [Types::PostType]

    option :filter, type: Inputs::Filters::PostFilter, with: :apply_filter

    def apply_filter(scope, value)
      scope.search_by_title(value.to_h[:title])
    end
  end
end
