class Coindcx::FundService

  def initialize options={}
    @key, @secret, @options = Settings.coindcx.key, Settings.coindcx.secret, options
  end

  def execute bot, options={}
    update_funds(bot, options)
  end

  private

    def update_funds bot, options={}
      payload = {
        timestamp: Time.new.to_i
      }.to_json

      signature = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), @secret, payload)
      headers = {
      'Content-Type' => 'application/json',
      'X-AUTH-APIKEY' => @key, 
      'X-AUTH-SIGNATURE' => signature
      }

      uri = URI.parse("#{Settings.coindcx.base_url}#{Settings.coindcx.balance}")
      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true
      request = Net::HTTP::Post.new(uri.path, headers)
      request.body = payload
      response = https.request(request)
      respons_body = JSON.parse(response.body)
      ccodes = CacheModule.ccodes
      if response.code == "200"
        respons_body.each do |wallet|
          if ccodes.include?(wallet["currency"])
            user_wallet = bot.user.wallets.find_by(ccode: wallet["currency"])
            user_wallet.update(balance: wallet["balance"])
          end
        end
      else
        AlertService.new.action_required("DCX - could not get balances", {message: respons_body})
      end
    end

    attr_reader :key, :secret, :options
end

=begin
cfs = Coindcx::FundService.new({})
cfs.execute(bot, {})
=end