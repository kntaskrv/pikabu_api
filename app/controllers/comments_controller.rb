class CommentsController < ApplicationController
  attr_reader :comment

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
