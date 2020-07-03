class ApplicationController < ActionController::API
  include Pundit
  include Pagy::Backend

  before_action :authenticate_user

  attr_reader :current_user

  protected

  def authenticate_user
    @current_user = user
  end

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
