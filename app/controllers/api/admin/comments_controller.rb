module Api
  module Admin
    class CommentsController < ApplicationController
      def destroy
        authorize comment
        if comment.destroy
          render json: { message: 'Comment deleted' }, status: :ok
        else
          render json: { errors: comment.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def comment
        @comment || Comment.find(params[:id])
      end
    end
  end
end
