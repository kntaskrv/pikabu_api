module Types
  class MutationType < Types::BaseObject
    field :create_user, mutation: Mutations::CreateUser
    field :create_comment, mutation: Mutations::CreateComment
    field :create_post, mutation: Mutations::CreatePost
    field :create_rate, mutation: Mutations::CreateRate
    field :create_bookmark, mutation: Mutations::CreateBookmark
    field :create_tag, mutation: Mutations::CreateTag
    field :update_tag, mutation: Mutations::UpdateTag
    field :delete_tag, mutation: Mutations::DeleteTag
    field :delete_post, mutation: Mutations::DeletePost
    field :delete_comment, mutation: Mutations::DeleteComment
    field :delete_user, mutation: Mutations::DeleteUser
  end
end
