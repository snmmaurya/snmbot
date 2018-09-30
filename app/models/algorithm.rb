class Algorithm < Concerns::OdmWrapper
  STATUSES = {"0"=>"active", "1"=>"inactive"}
  field :min_max_different, type: BigDecimal, default: 0.0
  field :quantity_to_sell, type: BigDecimal, default: 0.0
  field :quantity_to_buy, type: BigDecimal, default: 0.0
  field :description, type: String, default: ""
  field :status, type: Integer, default: 0

  belongs_to :bot
end