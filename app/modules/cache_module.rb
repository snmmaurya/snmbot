module CacheModule
  def self.ccodes
    Rails.cache.fetch ["ccodes"], expires_in: 50.minutes do
      Currency.all.pluck(:ccode)
    end
  end
end