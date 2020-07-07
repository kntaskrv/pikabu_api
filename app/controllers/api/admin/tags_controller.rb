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
        authorize tag
        if tag.update(tag_params)
          render json: { tag: tag }, status: :ok
        else
          render json: { errors: tag.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
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

      def tag
        @tag || Tag.find(params[:id])
      end
    end
  end
end
