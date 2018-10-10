class Wallet < Concerns::OdmWrapper
  STATUSES = {"0"=>"active", "1"=>"inactive"}

  field :title, type: String, default: ""
  field :ccode, type: String, default: ""
  field :balance, type: BigDecimal, default: 0.0
  field :locked_balance, type: BigDecimal, default: 0.0
  field :status, type: Integer, default: 0

  belongs_to :user
  index({ exchange: 1 }, {name: "wallet_user_index" })
end