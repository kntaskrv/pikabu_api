module Types
  class QueryType < Types::BaseObject
    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    field :all_users, [UserType], null: false
    def all_users
      User.order(rate: :desc)
    end

    field :tags, [TagType], null: false
    def tags
      Tag.all
    end

    field :all_posts, [PostType], null: false, resolver: Resolvers::PostsSearch
    field :posts_by_title, [PostType], null: false, resolver: Resolvers::PostsSearchByTitle
    field :bookmarks, [BookmarkableType], null: false, resolver: Resolvers::BookmarkResolver
    field :all_comments, [CommentType], null: false, resolver: Resolvers::CommentsSearch
  end
end
