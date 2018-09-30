class Bot < Concerns::OdmWrapper
  STATUSES = {"0"=>"active", "1"=>"inactive"}
  field :title, type: String, default: ""
  field :ecode, type: String, default: ""
  field :pair, type: String, default: ""
  field :min_max_different, type: BigDecimal, default: 0.0
  field :status, type: Integer, default: 0
  field :buy_fee, type: BigDecimal, default: 0.0
  field :sell_fee, type: BigDecimal, default: 0.0
  field :quantity_to_sell, type: BigDecimal, default: 0.0
  field :quantity_to_buy, type: BigDecimal, default: 0.0

  belongs_to :user
  belongs_to :exchange
  belongs_to :market

  embeds_many :algorithms
end