class Coindcx::DataService

  def initialize options={}
    @key, @secret, @options = Settings.coindcx.key, Settings.coindcx.secret, options
  end

  def execute options={}
    set_data(options)
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

    attr_reader :key, :secret, :options
end

=begin
cs = Coindcx::DataService
cs.execute()
=end