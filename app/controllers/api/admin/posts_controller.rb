module Api
  module Admin
    class PostsController < ApplicationController
      def destroy
        authorize post

        if post.destroy
          post.index
          render json: { message: 'Post deleted' }, status: :ok
        else
          render json: { errors: post.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def post
        @post || Post.find(params[:id])
      end
    end
  end
end
