module Api
  module V1
    class PostsController < ApplicationController
      attr_reader :post

      def index
        @pagy, @posts = pagy(Post.all)
        @posts = @posts.send(params[:filter]) if params[:filter]
        @posts = @posts.send(params[:order]) if params[:order]
        render json: { data: @posts }
      end

      def create
        @post = Post.create!(user: user, title: params[:title], description: params[:description])
        add_images if files
        add_tags if tags
      end

      private

      def add_images
        files.each do |file|
          post.images.create!(image: file)
        end
      end

      def add_tags
        tags.each do |tag|
          post.tags.create!(tag: tag)
        end
      end

      def tags
        @tags || params[:tags].split(',')
      end
    end
  end
end
