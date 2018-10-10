class Coindcx::DataWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'critical'

  def perform
    Coindcx::DataService.new.execute
  end
end