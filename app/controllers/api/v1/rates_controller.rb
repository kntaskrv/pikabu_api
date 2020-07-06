module Api
  module V1
    class RatesController < ApplicationController
      def create
        return render json: { error: "#{params[:type]} not found" } unless rateable

        rate = rateable.rates.new(rate_params)
        if rate.save
          render json: { message: 'Rate created' }, status: :ok
        else
          render json: { error: rate.errors.full_messages }
        end
      rescue NameError
        render json: { error: 'Wrong type' }
      end

      private

      def rate_params
        {
          user: user,
          status: params[:status] || 'like'
        }
      end

      def rateable
        @markable || params[:type].constantize.find_by(id: params[:id])
      end
    end
  end
end
