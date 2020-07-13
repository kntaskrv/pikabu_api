module Inputs
  module Filters
    class CommentFilter < ::Types::BaseInputObject
      argument :order, String, required: false
      argument :rating, Integer, required: false
      argument :date_start, String, required: false
      argument :date_end, String, required: false
      argument :find_user_id, Integer, required: false
      argument :post_id, Integer, required: false
    end
  end
end
