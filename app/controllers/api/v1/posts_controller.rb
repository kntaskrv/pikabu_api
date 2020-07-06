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
          pagy: pagy_metadata(@pagy)
        }
      end

      def create
        @post = Post.new(post_params)
        add_images if files
        add_tags if tags
        if @post.save
          render json: @post, status: :ok
        else
          render json: { error: @post.errors.full_messages }
        end
      end

      private

      def post_params
        params.permit(:title, :description, :user_id)
      end

      def add_images
        files.each do |file|
          post.images.new(image: file)
        end
      end

      def add_tags
        tags.each do |tag_id|
          tag = Tag.find_by(id: tag_id)
          post.tags << tag if tag
        end
      end

      def files
        @files || params[:files]
      end

      def tags
        @tags || params[:tags].split(',')
      end
    end
  end
end
