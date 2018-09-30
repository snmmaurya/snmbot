namespace :data do

  task :coindcx => :environment  do
    Rails.logger.info("Cron - data coindcx started")
    Coindcx::DataService.new.execute
    Rails.logger.info("Cron - data coindcx completed")
  end

end