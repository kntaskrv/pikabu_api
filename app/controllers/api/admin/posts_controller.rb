module Api
  module Admin
    class PostsController < ApplicationController
      def destroy
        post = Post.find(params[:id])
        authorize post
        post.destroy
      end
    end
  end
end
