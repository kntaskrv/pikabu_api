module Api
  module V1
    class CommentsController < ApplicationController
      attr_reader :comment

      def index
        comments = Comments::Load.call(find_params)
        @pagy, @comments = pagy_array(comments)
        render json: {
          comments: ActiveModel::Serializer::CollectionSerializer.new(
            @comments,
            serializer: CommentSerializer
          ),
          pagy: pagy_metadata(@pagy).slice(:page, :next, :last)
        }, status: :ok
      end

      def create
        return render json: { error: 'Wrong type' }, status: :bad_request unless type_valid?

        @comment = commentable.comments.new(comment_param.merge(user: user))
        add_images if files
        if @comment.save
          render json: @comment, status: :ok
        else
          render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def type_valid?
        %w[post comment].include?(params[:type]&.downcase)
      end

      def find_params
        params.permit(:find_user_id, :post_id, :date_start, :date_end, :rating, :order)
      end

      def comment_param
        params.permit(:text)
      end

      def commentable
        @commentable || params[:type]&.capitalize&.constantize&.find(params[:id])
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
