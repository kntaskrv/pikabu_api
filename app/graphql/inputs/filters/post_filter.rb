module Inputs
  module Filters
    class PostFilter < ::Types::BaseInputObject
      argument :title, String, required: false
      argument :filter, String, required: false
      argument :order, String, required: false
      argument :rating, Integer, required: false
      argument :date_start, String, required: false
      argument :date_end, String, required: false
    end
  end
end
