module Mutations
  class CreateRate < Mutations::BaseMutation
    argument :rateable_id, ID, required: true
    argument :rateable_type, String, required: true
    argument :status, String, required: true

    field :result, String, null: false

    attr_reader :args

    def resolve(**args)
      @args = args

      { result: Rates::Create.call(current_user, args) }
    end
  end
end
