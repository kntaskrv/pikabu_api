module Api
  module V1
    class CommentsController < ApplicationController
      attr_reader :comment

      def index
        @pagy, @comments = pagy(post.comments)
        @comments = @comments.send(params[:order]) if params[:order]
        render json: {
          posts: ActiveModel::Serializer::CollectionSerializer.new(
            @comments,
            serializer: CommentSerializer
          ),
          pagy: pagy_metadata(@pagy).slice(:page, :next, :last)
        }
      end

      def create
        @comment = post.comments.new(user: user, text: params[:text])
        add_images if files
        if @comment.save
          render json: @comment, status: :ok
        else
          render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def post
        @post || Post.find(params[:post_id])
      end

      def files
        @files || params[:files]
      end

      def add_images
        files.each do |file|
          comment.images.new(image: file)
        end
      end
    end
  end
end
