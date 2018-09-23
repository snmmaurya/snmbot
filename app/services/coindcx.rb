class Coindcx

  def initialize options={}
    @key, @secret, @options = Settings.coindcx.key, Settings.coindcx.secret, options
  end

  def execute symbol, options={}
    # logic goes here to place either limit/market
    # if side is not present inside options
    place_market_order symbol, options
  end

  private

    def place_limit_order symbol, options={}
      payload = {
        side: options["side"],
        order_type: "limit_order",
        price_per_unit: 0.00001724,
        market: symbol,
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
      response = https.request(request)
    end

    def place_market_order symbol, options={}
      payload = {
        side: options[:side],
        order_type: "market_order",
        market: symbol,
        total_quantity: options[:quantity],
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
      response = https.request(request)
      orders = JSON.parse(response.body)
      order = orders["orders"][0]
      iorder = Order.create({
        side: options[:side],
        fee: order["fee"],
        quantity: options[:quantity],
        symbol: symbol,
        order_type: 'market'
      })
    end

    attr_reader :key, :secret, :options
end

=begin
cs = Coindcx.new
cs.execute('XRPBTC', {side: 'sell', quantity: 5})
=end