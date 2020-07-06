module Api
  module V1
    class BookmarksController < ApplicationController
      def index
        @pagy, @bookmarks = pagy(user.bookmarks)
        @bookmarks = @bookmarks.where(markable_type: params[:type]) if params[:type]
        render json: { data: @bookmarks }
      end

      def create
        params[:type].constantize.find(params[:id]).bookmarks.create!(user: user)
      end
    end
  end
end
