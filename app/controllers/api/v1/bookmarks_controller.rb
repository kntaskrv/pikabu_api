module Api
  module V1
    class BookmarksController < ApplicationController
      def index
        return render json: { error: "Type can't be blank" } if params[:type].blank?

        return render json: { error: 'Wrong type' } unless type_valid?

        @pagy, @bookmarks = pagy(user.bookmarks)
        @bookmarks = @bookmarks.where(markable_type: params[:type]) if params[:type]
        render json: { data: @bookmarks, pagy: pagy_metadata(@pagy) }
      end

      def create
        return render json: { error: "#{params[:type]} not found" } unless markable

        mark = markable.bookmarks.new(mark_params)
        if mark.save
          render json: { message: 'Bookmark added' }, status: :ok
        else
          render json: { errors: mark.errors.full_messages }
        end
      rescue NameError
        render json: { error: 'Wrong type' }
      end

      private

      def type_valid?
        params[:type] == ('Post' || 'Comment')
      end

      def mark_params
        params.permit(:user_id)
      end

      def markable
        @markable || params[:type].constantize.find_by(id: params[:id])
      end
    end
  end
end
