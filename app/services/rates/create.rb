module Rates
  class Create < ServiceApplication
    param :user
    param :params

    def call
      argument_validate!
      return result if result[:errors].present?

      case check_rate
      when 'not exist'
        create_rate
      when 'same exist'
        @result[:message] = 'The same rate already exist'
        @result[:status] = :ok
      when 'diff exist'
        @result = Rates::Delete.call(rateable.user, rate, status)
      end
      result
    end

    private

    def check_rate
      return 'not exist' unless rate

      return 'same exist' if rate.status == params[:status]

      'diff exist'
    end

    def create_rate
      rating = user.rates.new(rateable: rateable, status: params[:status])
      if rating.save
        @result[:message] = 'Rate created'
        @result[:status] = :ok
        UserChangeRateJob.set(wait: 5.seconds).perform_later(rateable.user, rating.status)
      else
        @result[:errors] = rating.errors.full_messages
        @result[:status] = :unprocessable_entity
      end
    end

    def rate
      @rate || user.rates.find_by(rateable: rateable)
    end

    def argument_validate!
      @result[:errors][:type] = "Wrong type" unless type_valid?
      @result[:errors][:status] = "Wrong status" unless status_valid?
      @result[:status] = :unprocessable_entity if result[:errors].present?
    end

    def status_valid?
      %w[like dislike].include?(params[:status]&.downcase)
    end

    def type_valid?
      %w[post comment].include?(params[:rateable_type]&.downcase)
    end

    def rateable
      @rateable || params[:rateable_type].capitalize.constantize.find(params[:rateable_id])
    end
  end
end
