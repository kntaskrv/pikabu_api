class UserChangeRateJob < ApplicationJob
  queue_as :default

  def perform(user, status)
    status == 'like' ? user.rate += 1 : user.rate -= 1
    user.save
  end
end
