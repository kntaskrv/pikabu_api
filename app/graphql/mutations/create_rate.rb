module Mutations
  class CreateRate < Mutations::BaseMutation
    argument :rateable_id, ID, required: true
    argument :rateable_type, String, required: true
    argument :status, String, required: true

    field :message, String, null: false

    attr_reader :args

    def resolve(**args)
      @args = args
      argument_validate!

      result = Rates::Create.call(current_user, rateable, status: args[:status])

      { message: result[:message] }
    end

    private

    def current_user
      @current_user || context[:current_user]
    end

    def argument_validate!
      raise Exceptions::ValidationError, "Wrong type" unless type_valid?
      raise Exceptions::ValidationError, "Wrong status" unless status_valid?
    end

    def status_valid?
      %w[like dislike].include?(args[:status]&.downcase)
    end

    def type_valid?
      %w[post comment].include?(args[:rateable_type]&.downcase)
    end

    def rateable
      @rateable || args[:rateable_type]&.capitalize&.constantize&.find(args[:rateable_id])
    end
  end
end
