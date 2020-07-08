module Api
  module V1
    class RatesController < ApplicationController
      def create
        return render json: { error: 'Wrong type' }, status: :bad_request unless type_valid?

        return render json: { error: 'Wrong status' }, status: :bad_request unless status_valid?

        result = Rates::Create.call(user, rateable, status: params[:status])
        render json: { message: result[:message] }, status: result[:status]
      end

      private

      def type_valid?
        %w[post comment].include?(params[:type]&.downcase)
      end

      def status_valid?
        %w[like dislike].include?(params[:status]&.downcase)
      end

      def rateable
        @rateable || params[:type]&.capitalize&.constantize&.find(params[:id])
      end
    end
  end
end
