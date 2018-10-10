class Market
  include Mongoid::Document
  include Mongoid::Timestamps

  STATUSES = {"0"=>"active", "1"=>"inactive"}
  field :title, type: String, default: ""
  field :ecode, type: String, default: ""
  field :mcode, type: String, default: ""
  field :status, type: Integer, default: 0
  # field :base_market
  # field :target_market

  belongs_to :exchange

  index({ exchange: 1 }, {name: "market_exchange_index" })
end