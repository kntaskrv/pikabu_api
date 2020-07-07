module Api
  module Admin
    class TagsController < ApplicationController
      def create
        tag = Tag.new(tag_params)
        authorize tag
        if tag.save
          render json: { tag: tag }, status: :ok
        else
          render json: { errors: tag.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        tag = load_tag
        return render json: { error: 'Tag not found' } unless tag

        authorize tag

        if tag.update(tag_params)
          render json: { tag: tag }, status: :ok
        else
          render json: { errors: tag.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        tag = load_tag
        return render json: { message: 'Tag already deleted' }, status: :ok unless tag

        authorize tag

        if tag.destroy
          render json: { message: 'Tag deleted' }, status: :ok
        else
          render json: { errors: tag.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def tag_params
        params.permit(:tag)
      end

      def load_tag
        Tag.find(params[:id])
      end
    end
  end
end
