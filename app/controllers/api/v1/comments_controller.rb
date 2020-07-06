module Api
  module V1
    class CommentsController < ApplicationController
      attr_reader :comment

      def index
        @pagy, @comments = pagy(Comment.all)
        @comments = @comments.send(params[:order]) if params[:order]
        render json: { data: @comments }
      end

      def create
        @comment = post.comments.create!(user: user, text: params[:text])
        add_images if files
      end

      private

      def add_images
        files.each do |file|
          comment.images.create!(image: file)
        end
      end
    end
  end
end
