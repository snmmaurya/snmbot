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
      "exchange_price" => RedisModule.fetch_current_price("DCX", bot.pair)
    }
    place_market_order bot.pair, options
  end

  private

    def place_limit_order pair, options={}
      payload = {
        side: options["side"],
        order_type: "limit_order",
        price_per_unit: 0.00001724,
        market: pair,
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

    def place_market_order pair, options={}
      payload = {
        side: options["side"],
        order_type: "market_order",
        market: pair,
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
        pair: pair,
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