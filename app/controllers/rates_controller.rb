class RatesController < ApplicationController
  def create
    params[:type].constantize.find(params[:id]).rates.create!(user: user, status: params[:status])
  end
end
