namespace :coindcx do

  task :start => :environment  do
    Rails.logger.info("Cron - Coindcx started At: #{Time.new}")
    # exchange = Exchange.find_by ecode: "DCX"

    # # Worker to collect data
    # Coindcx::DataWorker.perform_async()

    # # Bot.where(ecode: "DCX").each do |bot|
    # #   Coindcx::FundWorker.perform_async(bot.id)
    # # end

    # # Wroker to execute individual bot
    # Bot.where(ecode: "DCX").each do |bot|
    #   Coindcx::ExecutorWorker.perform_async(bot.id)
    # end
  end

end