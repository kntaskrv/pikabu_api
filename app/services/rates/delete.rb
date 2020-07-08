module Rates
  class Delete < ServiceApplication
    param :user
    param :rate

    def call
      if rate.destroy
        @result[:message] = 'Rate deleted'
        @result[:status] = :ok
        UserChangeRateJob.set(wait: 5.minutes).perform_later(user, rate)
      else
        @result[:errors] = rate.errors.full_messages
        @result[:status] = :unprocessable_entity
      end
      result
    end
  end
end
