class Algorithm
  include Mongoid::Document
  include Mongoid::Timestamps

  STATUSES = {"0"=>"active", "1"=>"inactive"}
  field :mcode, type: String, default: ""
  field :min_max_different, type: BigDecimal, default: 0.0
  field :quantity_to_sell, type: BigDecimal, default: 0.0
  field :quantity_to_buy, type: BigDecimal, default: 0.0
  field :description, type: String, default: ""
  field :status, type: Integer, default: 0

  embedded_in :bot
end