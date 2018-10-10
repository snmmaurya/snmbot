class Coindcx::ExecutorWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'default'

  def perform bot_id
    bot = Bot.find(bot_id)
    cs = Coindcx::ExecutorService.new(bot)
    cs.execute({})
  end
end