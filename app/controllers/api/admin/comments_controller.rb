module Api
  module Admin
    class CommentsController < ApplicationController
      def destroy
        comment = Comment.find(params[:id])
        authorize comment
        if comment.destroy
          render json: { message: 'Comment deleted' }, status: :ok
        else
          render json: { errors: comment.errors.full_messages }, status: :unprocessable_entity
        end
      end
    end
  end
end
