module Api
  module V1
    class RatesController < ApplicationController
      def create
        result = Rates::Create.call(user, rateable, status: params[:status])

        render json: { result: result }, status: result[:status]
      end
    end
  end
end
