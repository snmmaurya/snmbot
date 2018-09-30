class Executor::CoindcxWorker
  include Sidekiq::Worker

  def perform bot_id
    bot = Bot.find(bot_id)
    

    # TODO
    # algorithm to calculate
    # when to place sell/buy order
    # when to place limit order/market order
    # when to place stop limit order

    cs = Coindcx::ExecutorService.new
    cs.execute(bot, {})
  end
end