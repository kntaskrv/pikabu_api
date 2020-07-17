module Api
  module V1
    class PostsController < ApplicationController
      attr_reader :post

      def index
        posts = Posts::Load.call(find_params)
        @pagy, @posts = pagy_array(posts)

        render json: {
          posts: ActiveModel::Serializer::CollectionSerializer.new(
            @posts,
            serializer: PostSerializer
          ),
          pagy: pagy_metadata(@pagy).slice(:page, :next, :last)
        }, status: :ok
      end

      def find_by_title
        @pagy, @posts = pagy(Post.search_by_title(params[:title]))

        render json: {
          posts: ActiveModel::Serializer::CollectionSerializer.new(
            @posts,
            serializer: PostSerializer
          ),
          pagy: pagy_metadata(@pagy).slice(:page, :next, :last)
        }, status: :ok
      end

      def create
        return render json: { message: 'Your rating too low for creating posts' }, status: :ok if user.bad_rating?

        @post = user.posts.new(post_params)
        add_images if files
        add_tags if tags

        if @post.save
          render json: @post, status: :ok
        else
          render json: { error: @post.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def post_params
        params.permit(:title, :description)
      end

      def find_params
        params.permit({ tags: [] }, :title, :date_start, :date_end, :rating, :filter, :order)
      end

      def add_images
        files.each do |file|
          post.images.new(image: file)
        end
      end

      def add_tags
        post.tags = Tag.where(id: tags)
      end

      def files
        @files || params[:files]
      end

      def tags
        @tags || params[:tags]
      end
    end
  end
end
