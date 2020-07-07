module Api
  module V1
    class PostsController < ApplicationController
      attr_reader :post

      def index
        @pagy, @posts = pagy(Post.all)
        @posts = @posts.send(params[:filter]) if params[:filter]
        @posts = @posts.send(params[:order]) if params[:order]
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

      def add_images
        files.each do |file|
          post.images.new(image: file)
        end
      end

      def add_tags
        Tag.where(id: tags).each do |tag|
          post.tags << tag
        end
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
