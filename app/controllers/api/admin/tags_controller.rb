module Api
  module Admin
    class TagsController < ApplicationController
      def create
        tag = Tag.new(tag_params)
        authorize tag
        if tag.save
          render json: { tag: tag }, status: :ok
        else
          render json: { errors: tag.errors.full_messages }
        end
      end

      def update
        tag = load_tag
        return render json: { error: 'Tag not found' } unless tag

        authorize tag

        if tag.update(tag_params)
          render json: { tag: tag }, status: :ok
        else
          render json: { errors: tag.errors.full_messages }
        end
      end

      def destroy
        tag = load_tag
        return render json: { message: 'Tag already deleted' } unless tag

        authorize tag

        tag.destroy
        render json: { message: 'Tag deleted' }
      end

      private

      def tag_params
        params.permit(:tag)
      end

      def load_tag
        Tag.find_by(id: params[:id])
      end
    end
  end
end
