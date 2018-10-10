class Market < Concerns::OdmWrapper
  STATUSES = {"0"=>"active", "1"=>"inactive"}
  field :title, type: String, default: ""
  field :mcode, type: String, default: ""
  field :status, type: Integer, default: 0

  belongs_to :exchange

  index({ exchange: 1 }, {name: "market_exchange_index" })
end