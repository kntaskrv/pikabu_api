class ApplicationController < ActionController::API
  include Pundit
  include Pagy::Backend

  before_action :authenticate_user
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  attr_reader :current_user

  protected

  def user_not_authorized
    render json: { error: 'You are not authorized to perform this action' }
  end

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
