module Api
  module Admin
    class UsersController < ApplicationController
      def destroy
        user = User.find(params[:id])
        authorize user
        user.destroy
      end
    end
  end
end
