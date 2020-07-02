class PostsController < ApplicationController
  attr_reader :post

  def index; end

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

  def files
    @files || params[:files]
  end

  def tags
    @tags || params[:tags].split(',')
  end
end
