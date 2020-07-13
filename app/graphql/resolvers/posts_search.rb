require 'search_object'
require 'search_object/plugin/graphql'

module Resolvers
  class PostsSearch
    include SearchObject.module(:graphql)

    scope { Post.all }

    type [Types::PostType]

    option :filter, type: Inputs::Filters::PostFilter, with: :apply_filter
    option :first, type: types.Int, with: :apply_first
    option :skip, type: types.Int, with: :apply_skip

    def apply_filter(_scope, value)
      filter_options = value.to_h

      result = Posts::Load.call(filter_options)

      result
    end

    def apply_first(scope, value)
      scope.limit(value)
    end

    def apply_skip(scope, value)
      scope.offset(value)
    end
  end
end
