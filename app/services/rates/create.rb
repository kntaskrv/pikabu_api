module Rates
  class Create < ServiceApplication
    param :user
    param :rateable

    option :status, default: -> { 'like' }

    def call
      case check_rate
      when 'not exist'
        create_rate
      when 'same exist'
        @result[:message] = 'The same rate already exist'
        @result[:status] = :ok
      when 'diff exist'
        @result = Rates::Delete.call(rateable.user, rate)
      end
      result
    end

    private

    def check_rate
      return 'not exist' unless rate

      return 'same exist' if rate.status == status

      'diff exist'
    end

    def create_rate
      rating = user.rates.new(rateable: rateable, status: status)
      if rating.save
        @result[:message] = 'Rate created'
        @result[:status] = :ok
        UserChangeRateJob.set(wait: 5.minutes).perform_later(rateable.user, rating)
      else
        @result[:errors] = rating.errors.full_messages
        @result[:status] = :unprocessable_entity
      end
    end

    def rate
      @rate || user.rates.find_by(rateable: rateable)
    end
  end
end
