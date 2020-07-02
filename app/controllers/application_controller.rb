class ApplicationController < ActionController::API
  protected

  def user
    @user || User.find_by!(name: params[:username])
  end
end
