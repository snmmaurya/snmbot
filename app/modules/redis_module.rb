module RedisModule
  def self.fetch_ticker ecode, pair
    $redis.hgetall("#{ecode}##{pair}")
  end

  def self.fetch_current_price ecode, pair
    ticker = RedisModule.fetch_ticker ecode, pair
    ticker["current_price"].to_d
  end

  def self.fetch_high_price ecode, pair
    ticker = RedisModule.fetch_ticker ecode, pair
    ticker["high_price"].to_d
  end

  def self.fetch_low_price ecode, pair
    ticker = RedisModule.fetch_ticker ecode, pair
    ticker["low_price"].to_d
  end

  def self.fetch_best_bid ecode, pair
    ticker = RedisModule.fetch_ticker ecode, pair
    ticker["best_ask"].to_d
  end

  def self.fetch_best_ask ecode, pair
    ticker = RedisModule.fetch_ticker ecode, pair
    ticker["best_bid"].to_d
  end

  def self.change_24_hour ecode, pair
    ticker = RedisModule.fetch_ticker ecode, pair
    ticker["change_24_hour"].to_d
  end
end