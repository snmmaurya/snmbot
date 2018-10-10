class Coindcx::ExecutorWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'default'

  def perform bot_id
    bot = Bot.find(bot_id)
    
    ticker = RedisModule.fetch_ticker(bot.ecode, bot.mcode)
    high_price = ticker["high_price"].to_f
    low_price = ticker["low_price"].to_f
    current_price = ticker["current_price"].to_f
    change_24_hour = ticker["change_24_hour"].to_f
    
    # bot.change_24_hour -
    # required to go ahead to place an order
    # here if 
    if change_24_hour >= bot.change_24_hour
      
    end
    # TODO
    # algorithm to calculate
    # when to place sell/buy order
    # when to place limit order/market order
    # when to place stop limit order

    cs = Coindcx::ExecutorService.new
    cs.execute(bot, {})
  end
end

=begin
  check fund/balance

  when to sell
  when to buy
=end