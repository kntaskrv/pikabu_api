module Api
  module V1
    class UsersController < ApplicationController
      def index
        @pagy, @users = pagy(User.order(rate: :desc))

        render json: {
          users: ActiveModel::Serializer::CollectionSerializer.new(
            @users,
            serializer: UserSerializer
          ),
          pagy: pagy_metadata(@pagy).slice(:page, :next, :last)
        }, status: :ok
      end
    end
  end
end
