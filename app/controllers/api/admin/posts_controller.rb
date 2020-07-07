module Api
  module Admin
    class PostsController < ApplicationController
      def destroy
        post = Post.find(params[:id])
        authorize post
        if post.destroy
          render json: { message: 'Post deleted' }, status: :ok
        else
          render json: { errors: post.errors.full_messages }, status: :unprocessable_entity
        end
      end
    end
  end
end
