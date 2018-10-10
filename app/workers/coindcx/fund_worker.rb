class Coindcx::FundWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'critical'

  def perform bot_id
    bot = Bot.find(bot_id)
    Coindcx::FundService.new.execute(bot)
  end
end