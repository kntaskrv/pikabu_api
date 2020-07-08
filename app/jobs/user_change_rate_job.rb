class UserChangeRateJob < ApplicationJob
  queue_as :default

  def perform(user, rate)
    rate.status == 'like' ? user.rate += 1 : user.rate -= 1
    user.save
  end
end
