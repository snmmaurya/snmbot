class Coindcx::ExecutorService

  def initialize bot, options={}
    @key, @secret, @bot, @options = Settings.coindcx.key, Settings.coindcx.secret, bot options
    @user = @bot.user
    @btc_wallet = @bot.user.btc_wallet
    @btc_wallet_balance = @btc_wallet.balance
  end

  def negative_lies_into_data
    first, second, third = [], [], []

    @bot.algorithms.each do |algorithm|
      change_24_hour = RedisModule.change_24_hour @bot.ecode, algorithm.mcode
      if change_24_hour >= -20 && change_24_hour <= -15
        first.push(algorithm.mcode)
      elsif change_24_hour >= -14 && change_24_hour <= -7
        second.push(algorithm.mcode)
      elsif change_24_hour >= -6 && change_24_hour <= -1
        third.push(algorithm.mcode)
      end
    end

    return {
      "first" => first,
      "second" => second,
      "third" => third
    }
  end

  def buy_limit_order
    lies_data = lies_into_data

    if lies_data["first"].present?
      # 15 percent of btc wallet balance
      precente = @btc_wallet_balance * 15 / 100
      # average quantity
      quantity = precente / lies_data["first"].count

      @btc_wallet_balance = @btc_wallet_balance - precente

      lies_data["first"].each do |mcode|
        bids = JSON::parse(DcxOrderBook.find_by(mcode: mcode).data["bids"])
        price = bids.keys[4]
        options = {
          "side" => "buy",
          "quantity" => quantity,
          "price" => price,
          "exchange_price" => RedisModule.fetch_current_price(bot.ecode, bot.mcode)
        }
        place_limit_order mcode, options
      end
    end

    if lies_data["second"].present?
      # 55 percent of btc wallet balance
      precente = @btc_wallet_balance * 55 / 100
      # average quantity
      quantity = precente / lies_data["second"].count

      @btc_wallet_balance = @btc_wallet_balance - precente

      lies_data["second"].each do |mcode|
        bids = JSON::parse(DcxOrderBook.find_by(mcode: mcode).data["bids"])
        price = bids.keys[4]
        options = {
          "side" => "buy",
          "quantity" => quantity,
          "price" => price,
          "exchange_price" => RedisModule.fetch_current_price(bot.ecode, bot.mcode)
        }
        place_limit_order mcode, options
      end
    end

    if lies_data["third"].present?
      # 30 percent of btc wallet balance
      precente = @btc_wallet_balance * 30 / 100
      # average quantity
      quantity = precente / lies_data["third"].count

      @btc_wallet_balance = @btc_wallet_balance - precente

      lies_data["third"].each do |mcode|
        bids = JSON::parse(DcxOrderBook.find_by(mcode: mcode).data["bids"])
        price = bids.keys[4]
        options = {
          "side" => "buy",
          "quantity" => quantity,
          "price" => price,
          "exchange_price" => RedisModule.fetch_current_price(bot.ecode, bot.mcode)
        }
        place_limit_order mcode, options
      end
    end
  end

  def poisitive_lies_into_data
    first, second, third = [], [], []

    @bot.algorithms.each do |algorithm|
      currenct_price = RedisModule.fetch_current_price @bot.ecode, algorithm.mcode
      price = Order.where(mcode: algorithm.mcode, side: 1).order_by(created_at: :desc).last.try(:price)

      if currenct_price >= (price * 1.06)
        first.push(algorithm.mcode)
      elsif currenct_price >= (price * 1.04)
        second.push(algorithm.mcode)
      elsif currenct_price >= (price * 1.02)
        third.push(algorithm.mcode)
      end
    end

    return {
      "first" => first,
      "second" => second,
      "third" => third
    }
  end

  def sell_limit_order
    #(/exchange/v1/orders/trade_history)
    lies_data = poisitive_lies_into_data
    

    if lies_data["first"].present?
      # 15 percent of btc wallet balance
      precente = @btc_wallet_balance * 40 / 100
      # average quantity
      quantity = precente / lies_data["first"].count

      @btc_wallet_balance = @btc_wallet_balance - precente

      lies_data["first"].each do |mcode|
        bids = JSON::parse(DcxOrderBook.find_by(mcode: mcode).data["bids"])
        price = bids.keys[4]
        options = {
          "side" => "buy",
          "quantity" => quantity,
          "price" => price,
          "exchange_price" => RedisModule.fetch_current_price(bot.ecode, bot.mcode)
        }
        place_limit_order mcode, options
      end
    end

    if lies_data["second"].present?
      # 55 percent of btc wallet balance
      precente = @btc_wallet_balance * 55 / 100
      # average quantity
      quantity = precente / lies_data["second"].count

      @btc_wallet_balance = @btc_wallet_balance - precente

      lies_data["second"].each do |mcode|
        bids = JSON::parse(DcxOrderBook.find_by(mcode: mcode).data["bids"])
        price = bids.keys[4]
        options = {
          "side" => "buy",
          "quantity" => quantity,
          "price" => price,
          "exchange_price" => RedisModule.fetch_current_price(bot.ecode, bot.mcode)
        }
        place_limit_order mcode, options
      end
    end

    if lies_data["third"].present?
      # 30 percent of btc wallet balance
      precente = @btc_wallet_balance * 30 / 100
      # average quantity
      quantity = precente / lies_data["third"].count

      @btc_wallet_balance = @btc_wallet_balance - precente

      lies_data["third"].each do |mcode|
        bids = JSON::parse(DcxOrderBook.find_by(mcode: mcode).data["bids"])
        price = bids.keys[4]
        options = {
          "side" => "buy",
          "quantity" => quantity,
          "price" => price,
          "exchange_price" => RedisModule.fetch_current_price(bot.ecode, bot.mcode)
        }
        place_limit_order mcode, options
      end
    end
  end

  def execute options={}
    change_24_hour = RedisModule.change_24_hour @bot.ecode, algorithm.mcode

    if change_24_hour >= -20 && change_24_hour <= -1
      buy_limit_order
    elsif change_24_hour > 0
      sell_limit_order
    end
  end

  private

    def place_limit_order mcode, options={}
      payload = {
        side: options["side"],
        order_type: "limit_order",
        price_per_unit: options["price"],
        market: mcode,
        total_quantity: options["quantity"],
        timestamp: Time.new.to_i
      }.to_json

      signature = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), @secret, payload)
      headers = {
      'Content-Type' => 'application/json',
      'X-AUTH-APIKEY' => @key, 
      'X-AUTH-SIGNATURE' => signature
      }
      uri = URI.parse("#{Settings.coindcx.base_url}#{Settings.coindcx.create_order}")
      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true
      request = Net::HTTP::Post.new(uri.path, headers)
      request.body = payload
      # response = https.request(request)
      Rails.logger.info("Placing Limit Order")
      Rails.logger.info(payload)
    end

    def place_market_order mcode, options={}
      payload = {
        side: options["side"],
        order_type: "market_order",
        market: mcode,
        total_quantity: options["quantity"],
        timestamp: Time.new.to_i
      }.to_json

      signature = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), @secret, payload)
      headers = {
      'Content-Type' => 'application/json',
      'X-AUTH-APIKEY' => @key, 
      'X-AUTH-SIGNATURE' => signature
      }
      uri = URI.parse("#{Settings.coindcx.base_url}#{Settings.coindcx.create_order}")
      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true
      request = Net::HTTP::Post.new(uri.path, headers)
      request.body = payload
      # response = https.request(request)
      Rails.logger.info("Placing Market Order")
      Rails.logger.info(payload)


      Order.create!({
        quantity: options["quantity"],
        side: options["side"],
        remaining_quantity: options["quantity"],
        exchange_price: options["exchange_price"],
        order_type: "market_order",
        mcode: mcode,
        price: options["exchange_price"],
        user: User.first
      })
      # orders = JSON.parse(response.body)
      # order = orders["orders"][0]
      # iorder = Order.create({
      #   side: options[:side],
      #   fee: order["fee"],
      #   quantity: options[:quantity],
      #   symbol: pair,
      #   order_type: 'market'
      # })
    end

    attr_reader :key, :secret, :options
end

=begin
cs = Coindcx.new
cs.execute('XRPBTC', {side: 'sell', quantity: 5})
=end