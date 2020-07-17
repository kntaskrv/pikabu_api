module Rates
  class Delete < ServiceApplication
    param :user
    param :rate
    param :status

    def call
      if rate.destroy
        Sunspot.index! rate.rateable
        @result[:message] = 'Rate deleted'
        @result[:status] = :ok
        UserChangeRateJob.set(wait: 5.seconds).perform_later(user, status)
      else
        @result[:errors] = rate.errors.full_messages
        @result[:status] = :unprocessable_entity
      end
      result
    end
  end
end
