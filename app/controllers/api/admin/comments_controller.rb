module Api
  module Admin
    class CommentsController < ApplicationController
      def destroy
        comment = Comment.find(params[:id])
        authorize comment
        comment.destroy
      end
    end
  end
end
