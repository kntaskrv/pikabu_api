module Api
  module Admin
    class UsersController < ApplicationController
      def destroy
        user = User.find(params[:id])
        authorize user

        if user.destroy
          user.index
          render json: { message: 'User deleted' }, status: :ok
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end
    end
  end
end
