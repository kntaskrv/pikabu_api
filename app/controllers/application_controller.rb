class ApplicationController < ActionController::API
  protected

  def user
    @user || User.find_by(id: params[:user_id]) || User.find_by!(name: params[:username])
  end

  def post
    @post || Post.find(params[:post_id])
  end

  def files
    @files || params[:files]
  end
end
