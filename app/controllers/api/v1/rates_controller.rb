module Api
  module V1
    class RatesController < ApplicationController
      def create
        result = Rates::Create.call(user, rate_params)

        render json: { result: result }, status: result[:status]
      end

      def rate_params
        params.permit(:status, :rateable_id, :rateable_type)
      end
    end
  end
end
