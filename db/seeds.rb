AdminUser.create(email: "admin@snmbot.com", password: "Pass#147", password_confirmation: "Pass#147")

Currency.create!(ccode: "BTC", title: "Bitcoin", status: 0)
Currency.create!(ccode: "XRP", title: "Ripple", status: 0)
Currency.create!(ccode: "LTC", title: "Litecoin", status: 0)
Currency.create!(ccode: "BCH", title: "Bcash", status: 0)
Currency.create!(ccode: "TRX", title: "Tron", status: 0)

user = User.create(email: "test0@snmbot.com", password: "Pass#147", password_confirmation: "Pass#147", first_name: "Cherry", last_name: "Cherry")

Currency.each do |currency|
  Wallet.create(user: user, ccode: currency.ccode, title: currency.title, status: 0)
end

user = User.create(email: "test1@snmbot.com", password: "Pass#147", password_confirmation: "Pass#147", first_name: "Blossom", last_name: "Blossom")
Currency.each do |currency|
  Wallet.create(user: user, ccode: currency.ccode, title: currency.title, status: 0)
end

coindcx = Exchange.create(title: "Coindcx", ecode: "DCX", status: 0)
binance = Exchange.create(title: "Binance", ecode: "BNC", status: 0)

Currency.each do |currency|
  dcx = Market.create(title: "#{currency.ccode}BTC", mcode: "#{currency.ccode}BTC", ecode: "DCX", exchange: coindcx, status: 0)
  bnc = Market.create(title: "#{currency.ccode}BTC", mcode: "#{currency.ccode}BTC", ecode: "BNC", exchange: binance, status: 0)
end

dcx_bot = Bot.create(title: "DCX BOT", ecode: "DCX", status: 0, user: User.first, exchange: coindcx)
bnc_bot = Bot.create(title: "BNC BOT", ecode: "BNC", status: 1, user: User.last, exchange: binance)


Market.where(ecode: 'DCX').each do |market|
  dcx_bot.algorithms.create!(mcode: market.mcode, status: 0)
end

Market.where(ecode: 'BNC').each do |market|
  bnc_bot.algorithms.create!(mcode: market.mcode, status: 0)
end