class Coindcx::DataWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'critical'

  def perform bot_id
    bot = Bot.find bot_id
    cds = Coindcx::DataService.new(bot)
    cds.execute
  end
end