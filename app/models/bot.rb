class Bot < Concerns::OdmWrapper
  STATUSES = {"0"=>"active", "1"=>"inactive"}
  field :title, type: String, default: ""
  field :ecode, type: String, default: ""
  field :mcode, type: String, default: ""

  field :min_max_different, type: BigDecimal, default: 0.0
  field :quantity_to_sell, type: BigDecimal, default: 0.0
  field :quantity_to_buy, type: BigDecimal, default: 0.0

  field :change_24_hour, type: BigDecimal, default: 0.0

  field :status, type: Integer, default: 0

  belongs_to :user
  belongs_to :exchange

  index({ user: 1 }, {name: "bot_user_index" })
  index({ exchange: 1 }, {name: "bot_exchange_index" })



  embeds_many :algorithms
end