namespace :executor do

  task :coindcx => :environment  do
    Rails.logger.info("Cron - Coindcx executor started")
    exchange = Exchange.find_by ecode: "DCX"
    Bot.where(ecode: "DCX").each do |bot|
      Executor::CoindcxWorker.perform_async(bot.id)
    end
    Rails.logger.info("Cron - Coindcx executor completed")
  end

end