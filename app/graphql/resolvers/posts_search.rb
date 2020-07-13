require 'search_object'
require 'search_object/plugin/graphql'

module Resolvers
  class PostsSearch
    include SearchObject.module(:graphql)

    scope { Post.all }

    type [Types::PostType]

    option :filter, type: Inputs::Filters::PostFilter, with: :apply_filter

    def apply_filter(_scope, value)
      Posts::Load.call(value.to_h)
    end
  end
end
