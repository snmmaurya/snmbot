class Coindcx::DataService

  def initialize bot, options={}
    @key, @secret= Settings.coindcx.key, Settings.coindcx.secret
    @bot, @options  = bot, options
  end

  def execute options={}
    set_data(options)
    set_order_book(options)
  end

  private

    def set_data options={}
      headers = {'Content-Type' => 'application/json'}
      uri = URI.parse("#{Settings.coindcx.base_url}#{Settings.coindcx.ticker}")
      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true
      request = Net::HTTP::Get.new(uri.path, headers)
      response = https.request(request)
      respons_body = JSON.parse(response.body)

      if response.code == "200"
        respons_body.each do |ticker|
          to_set=["DCX##{ticker["market"]}"]
          to_set.push("change_24_hour", ticker["change_24_hour"])
          to_set.push("high_price", ticker["high"])
          to_set.push("low_price", ticker["low"])
          to_set.push("current_price", ticker["last_price"])
          to_set.push("best_bid", ticker["bid"])
          to_set.push("best_ask", ticker["ask"])
          to_set.push("timestamp", ticker["timestamp"])
          $redis.hmset(to_set)
        end
      else
        AlertService.new.action_required("DCX - could not get tickers", {message: respons_body})
      end
    end

    def set_order_book options={}
      @bot.algorithms.each do |algorithm|
        headers = {'Content-Type' => 'application/json'}
        uri = URI.parse("#{Settings.coindcx.base_url}/exchange/v1/books/#{algorithm.mcode}")
        https = Net::HTTP.new(uri.host, uri.port)
        https.use_ssl = true
        request = Net::HTTP::Get.new(uri.path, headers)
        response = https.request(request)
        respons_body = JSON.parse(response.body)

        if response.code == "200"
          dob = DcxOrderBook.find_by mcode: algorithm.mcode
          if dob.present?
            dob.update!(data: {"bids" => respons_body["bids"].to_json, "asks" => respons_body["asks"].to_json})
          else
            dob = DcxOrderBook.create!(mcode: algorithm.mcode, data: {"bids" => respons_body["bids"].to_json, "asks" => respons_body["asks"].to_json})
          end
        else
          AlertService.new.action_required("DCX - could not get order books", {message: respons_body})
        end
      end
    end

    attr_reader :key, :secret, :options
end

=begin
cs = Coindcx::DataService
cs.execute()
=end