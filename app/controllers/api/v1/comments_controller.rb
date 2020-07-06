module Api
  module V1
    class CommentsController < ApplicationController
      attr_reader :comment

      def index
        return render json: { error: 'Post not found' } unless post

        @pagy, @comments = pagy(post.comments)
        @comments = @comments.send(params[:order]) if params[:order]
        render json: {
          posts: ActiveModel::Serializer::CollectionSerializer.new(
            @comments,
            serializer: CommentSerializer
          ),
          pagy: pagy_metadata(@pagy)
        }
      end

      def create
        @comment = post.comments.new(user: user, text: params[:text])
        add_images if files
        if @comment.save
          render json: @comment, status: :ok
        else
          render json: { errors: @comment.errors.full_messages }
        end
      end

      private

      def post
        @post || Post.find_by(id: params[:post_id])
      end

      def files
        @files || params[:files]
      end

      def add_images
        result = { errors: [] }
        files.each do |file|
          comment.images.new(image: file)
        end
        result
      end
    end
  end
end
