module Api
  module V1
    class BookmarksController < ApplicationController
      def index
        return render json: { error: "Type can't be blank" }, status: :bad_request if params[:type].blank?

        return render json: { error: 'Wrong type' }, status: :bad_request unless type_valid?

        @pagy, @bookmarks = pagy(user.bookmarks)
        @bookmarks = @bookmarks.where(markable_type: params[:type]) if params[:type]

        render json: {
          data: @bookmarks,
          pagy: pagy_metadata(@pagy).slice(:page, :next, :last)
        }, status: :ok
      end

      def create
        return render json: { error: 'Wrong type' }, status: :bad_request unless type_valid?

        mark = user.bookmarks.new(markable: markable)

        if mark.save
          Sunspot.index! markable
          render json: { message: 'Bookmark added' }, status: :ok
        else
          render json: { errors: mark.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def type_valid?
        %w[post comment].include?(params[:type]&.downcase)
      end

      def markable
        @markable || params[:type]&.capitalize&.constantize&.find(params[:id])
      end
    end
  end
end
