class HardWorker
  include Sidekiq::Worker

  def perform
    puts 'HELLO SIDEKIQ'
  end
end
