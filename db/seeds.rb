AdminUser.create(email: "admin@snmbot.com", password: "Pass#147", password_confirmation: "Pass#147")

User.create(email: "test0@snmbot.com", password: "Pass#147", password_confirmation: "Pass#147", first_name: "Cherry", last_name: "Cherry")
User.create(email: "test1@snmbot.com", password: "Pass#147", password_confirmation: "Pass#147", first_name: "Blossom", last_name: "Blossom")

coindcx = Exchange.create(title: "Coindcx", ecode: "DCX", status: 0)
binance = Exchange.create(title: "Binance", ecode: "BNC", status: 0)

dcx = Market.create(title: "XRPBTC", ecode: "DCX", exchange: coindcx, status: 0)
bnc = Market.create(title: "XRPBTC", ecode: "BNC", exchange: binance, status: 0)

Bot.create(title: "Bot-XRPBTC", ecode: "DCX", pair: "XRPBTC", status: 0, min_max_different: 5, user: User.first)
Bot.create(title: "Bot-XRPBTC", ecode: "BNC", pair: "LTCBTC", status: 1, min_max_different: 5, user: User.last)