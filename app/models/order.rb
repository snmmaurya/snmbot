class Order
  include Mongoid::Document
  include Mongoid::Timestamps

  # enum side: {sell: 0, buy: 1}
  # enum order_type: {market: 0, limit: 1}
  ORDER_TYPES = {"0"=>"market", "1"=>"limit"}
  SIDES = {"0"=>"sell", "1"=>"buy"}
  STATUSES = {"0"=>"open", "1"=>"filled", "2"=>"cancelled", "3"=>"rejected"}

  field :quantity, type: BigDecimal, default: 0.0
  field :price, type: BigDecimal, default: 0.0
  field :side, type: Integer, default: 0
  field :order_type, type: Integer, default: 0
  field :mcode, type: String, default: ""
  field :ecode, type: String, default: ""
  field :status, type: Integer, default: 0
  field :remaining_quantity, type: BigDecimal, default: 0
  field :exchange_price, type: BigDecimal, default: 0

  belongs_to :user

  index({ exchange: 1 }, {name: "order_user_index" })
end