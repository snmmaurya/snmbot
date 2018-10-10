class Coindcx::ExecutorService

  def initialize options={}
    @key, @secret, @options = Settings.coindcx.key, Settings.coindcx.secret, options
  end

  def execute bot, options={}
    # logic goes here to place either limit/market
    # if side is not present inside options

    options = {
      "side" => "sell",
      "quantity" => bot.quantity_to_sell,
      "exchange_price" => RedisModule.fetch_current_price("DCX", bot.mcode)
    }

    btc_pairs = ["XRPBTC", "LTCBTC", "BCHBTC"]

    changes = RedisModule.change_24_hour "DCX", "LTCBTC"
    if changes lies in (-1 to -20)
      if (-15 to -20)
         average =  5 pairs then (15 precent of btcamount) / 5
          PLACE BUY ORDER on average for each on price of 5th position of order book
          (/exchange/v1/books/:market) get order book and sort get 5th position(GREEN colors)
          remaing_balance = balance - (15 percent of balance)
      elsif (-7 to -14)
        average =  5 pairs then (55 precent of remaing_balance) / 5
          PLACE BUY ORDER on average for each on price of 5th position of order book
          (/exchange/v1/books/:market) get order book and sort get 5th position(GREEN colors)
          remaing_balance = balance - (15 percent of balance)

      elsif (-1 to -6)
        average =  5 pairs then (30 precent of remaing_balance) / 4
          PLACE BUY ORDER on average for each on price of 5th position of order book
          (/exchange/v1/books/:market) get order book and sort get 5th position(GREEN colors)
          remaing_balance = balance - (15 percent of balance)
      end
    elsif changes > 0
      refer order history of mine
      (/exchange/v1/orders/trade_history)
      xrp_btc_order
        side: "buy"
        price: 35
        quantity: 100
        
        currenct_price = RedisModule.fetch_current_price("DCX", "XRPBTC")

        percenteprice = 1.02 * price

        if (1.06 * price) >= percenteprice
          sell => 40 percent of xrp
        elsif (1.04 * price) >= percenteprice
          sell => 35 percent of xrp
        elsif (1.02 * price) >= percenteprice
          sell => 25 percent of xrp
        end
    end
   
    # when to invest



    place_market_order bot.mcode, options
  end

  private

    def place_limit_order mcode, options={}
      payload = {
        side: options["side"],
        order_type: "limit_order",
        price_per_unit: 0.00001724,
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