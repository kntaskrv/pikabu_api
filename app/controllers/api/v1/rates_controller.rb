module Api
  module V1
    class RatesController < ApplicationController
      def create
        return render json: { error: 'Wrong type' }, status: :bad_request unless type_valid?

        rate = rateable.rates.new(rate_params)
        if rate.save
          render json: { message: 'Rate created' }, status: :ok
        else
          render json: { error: rate.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def type_valid?
        %w[post comment].include?(params[:type]&.downcase)
      end

      def rate_params
        {
          user: user,
          status: params[:status] || 'like'
        }
      end

      def rateable
        @rateable || params[:type]&.capitalize&.constantize&.find(params[:id])
      end
    end
  end
end
