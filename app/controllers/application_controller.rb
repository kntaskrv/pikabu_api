class ApplicationController < ActionController::API
  include Pundit
  include Pagy::Backend

  before_action :authenticate_user
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :user_not_found

  attr_reader :current_user

  protected

  def user_not_authorized
    render json: { error: 'You are not authorized to perform this action' }
  end

  def user_not_found
    render json: { error: 'User not found' }
  end

  def authenticate_user
    @current_user = user
  end

  def user
    @user || User.find_by(id: params[:user_id]) || User.find_by!(name: params[:username])
  end
end
